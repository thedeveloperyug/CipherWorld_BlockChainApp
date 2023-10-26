import Text "mo:base/Text";
import Principal "mo:base/Principal";
import Cycles "mo:base/ExperimentalCycles";
import Debug "mo:base/Debug";
import HashMap "mo:base/HashMap";
import NFTActorClass "../nft/nft";
import List "mo:base/List";

actor OpenD {
   var mapOfNFTs = HashMap.HashMap<Principal, NFTActorClass.NFT>(1, Principal.equal, Principal.hash);
   var mapOfOwners = HashMap.HashMap<Principal, List.List<Principal>>(1, Principal.equal, Principal.hash);

   public shared (msg) func mint(imgData : [Nat8], name : Text) : async Principal {

      let owner : Principal = msg.caller;
      Debug.print(debug_show (Cycles.balance()));
      Cycles.add(100_500_000);

      let newNFT = await NFTActorClass.NFT(name, owner, imgData);

      let newNFTPrincipal = await newNFT.getCanisterId();
      Debug.print(debug_show (Cycles.balance()));

      mapOfNFTs.put(newNFTPrincipal, newNFT);
      addToOwnership(owner, newNFTPrincipal);

      return newNFTPrincipal

   };
   private func addToOwnership(owner : Principal, nftID : Principal) {
      var ownedNFTs : List.List<Principal> = switch (mapOfOwners.get(owner)) {
         case null List.nil<Principal>();
         case (?result) result;
      };
      ownedNFTs := List.push(nftID, ownedNFTs);
      mapOfOwners.put(owner, ownedNFTs);
   };

   public query func getOwnedNFTs(user : Principal) : async [Principal] {
      var userNFTs : List.List<Principal> = switch (mapOfOwners.get(user)) {
         case null List.nil<Principal>();
         case (?result) result;
      };
      return List.toArray(userNFTs);
   };

};
