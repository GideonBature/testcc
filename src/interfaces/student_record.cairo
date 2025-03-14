use starknet::ContractAddress;

#[starknet::interface]
pub trait IStudentRecord<TContractState> {
    fn borrow_book_from_library(ref self: TContractState, library_address: ContractAddress, book_name: felt252) -> bool;
}