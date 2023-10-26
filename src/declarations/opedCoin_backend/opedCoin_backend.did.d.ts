import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export interface _SERVICE {
  'getOwnedNFTs' : ActorMethod<[Principal], Array<Principal>>,
  'mint' : ActorMethod<[Uint8Array | number[], string], Principal>,
}
