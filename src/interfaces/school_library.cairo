#[starknet::interface]
pub trait ISchoolLibrary<TContractState> {
    fn add_book(ref self: TContractState, name: felt252);
    fn borrow_book(ref self: TContractState, name: felt252) -> bool;
}