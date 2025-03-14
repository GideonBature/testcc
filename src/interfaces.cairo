use starknet::ContractAddress;

#[starknet::interface]
pub trait ISchoolLibrary<TContractState> {
    fn add_book(ref self: TContractState, name: felt252);
    fn borrow_book(ref self: TContractState, name: felt252) -> bool;
}

#[starknet::interface]
pub trait IStudentRecord<TContractState> {
    fn borrow_book_from_library(ref self: TContractState, library_address: ContractAddress, book_name: felt252) -> bool;
}