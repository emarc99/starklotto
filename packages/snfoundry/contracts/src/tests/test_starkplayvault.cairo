#[cfg(test)]
mod tests {
    use crate::StarkPlayVault::{StarkPlayVault, IStarkPlayVaultDispatcher, IStarkPlayVaultDispatcherTrait, StarkPlayVault::Event::{MintLimitUpdated, BurnLimitUpdated} };
    use starknet::{contract_address_const, ContractAddress};
    use starknet::{storage::{StorableStoragePointerReadAccess}};
    use snforge_std::{start_cheat_caller_address, stop_cheat_caller_address, test_address};

// setting up the contract state
fn CONTRACT_STATE() -> StarkPlayVault::ContractState {
    StarkPlayVault::contract_state_for_testing()
}

fn init_vaullt() -> StarkPlayVault::ContractState {
    let mut state = StarkPlayVault::contract_state_for_testing();
    StarkPlayVault::constructor(
        ref state,
        contract_address_const::<'owner'>(), // owner
        contract_address_const::<'token'>(), // starkplay_token
        10000, // fee percentage
    );
    state
}

    const MAX_MINT_AMOUNT: u256 = 1_000_000 * 1_000_000_000_000_000_000; // 1 millón de tokens
    const MAX_BURN_AMOUNT: u256 = 1_000_000 * 1_000_000_000_000_000_000; // 1 millón de tokens


    #[test]
    fn test_set_mint_limit_by_owner() {
        // Setup
        let mut state = CONTRACT_STATE();
        let owner = contract_address_const::<5>();
        let new_limit = 1000_u256;
        let contract_address = test_address();

        // Check initial state
        let initial_state_limit = state.mintLimit.read();
        assert(initial_state_limit == MAX_MINT_AMOUNT, 'Wrong mint limit');

        // Set caller as owner
        start_cheat_caller_address(contract_address, owner);

        // set new mint limit
        state.setMintLimit(new_limit);

        // Verify
        let final_limit = state.mintLimit.read();
        assert(final_limit == new_limit, 'Mint limit not updated');

        // Check event emission (pseudo-code - actual event checking may vary)
        // let emitted_events = starknet::testing::get_emitted_events();
        // assert(emitted_events.len() == 1, 'Expected one event');
        // let event = emitted_events[0];
        // assert(event.keys.len() == 1, 'Event key mismatch');
        // assert(event.data.len() == 1, 'Event data mismatch');
        // assert(event.data[0] == new_limit, 'Event data incorrect');
    }
}