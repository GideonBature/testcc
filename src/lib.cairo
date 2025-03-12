use core::starknet::{ContractAddress, get_caller_address};

#[starknet::interface]
pub trait ISchoolLibrary<TContractState> {
    fn add_book(ref self: TContractState, name: felt252);
    fn borrow_book(ref self: TContractState, name: felt252) -> bool;
}

#[starknet::contract]
mod SchoolLibrary {
    use starknet::storage::{StoragePointerWriteAccess, StoragePointerReadAccess, StoragePathEntry};
    use starknet::storage::{Map};

    #[storage]
    struct Storage {
        books: Map<felt252, bool>,
    }

    #[abi(embed_v0)]
    impl SchoolLibraryImpl of super::ISchoolLibrary<ContractState> {
        fn add_book(ref self: ContractState, name: felt252) {
            self.books.entry(name).write(true);
        }

        fn borrow_book(ref self: ContractState, name: felt252) -> bool {
            assert!(self.books.entry(name).read() != false, "Book not available");

            self.books.entry(name).write(false);
        
            true
        }

    }
}

#[starknet::interface]
pub trait IStudentRecord<TContractState> {
    fn borrow_book_from_library(ref self: TContractState, library_address: ContractAddress, book_name: felt252) -> bool;
}

#[starknet::contract]
mod StudentRecord {
    use starknet::storage::StorageMapWriteAccess;
use super::ISchoolLibraryDispatcherTrait;
    use starknet::storage::{Map};
    use core::starknet::{ContractAddress, get_caller_address};
    use super::ISchoolLibraryDispatcher;

    #[storage]
    struct Storage {
        student_borrowed_books: Map<ContractAddress, felt252>,
    }

    impl StudentRecordImpl of super::IStudentRecord<ContractState> {
        fn borrow_book_from_library(ref self: ContractState, library_address: ContractAddress, book_name: felt252) -> bool {
            let library_dispatcher = ISchoolLibraryDispatcher { contract_address: library_address };

            if library_dispatcher.borrow_book(book_name) {
                let student = get_caller_address();
                self.student_borrowed_books.write(student, book_name);
                true
            } else {
                false
            }
        }
    }

}