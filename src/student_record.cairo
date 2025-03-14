#[starknet::contract]
mod StudentRecord {
    use starknet::storage::StorageMapWriteAccess;
    use super::ISchoolLibraryDispatcherTrait;
    use starknet::storage::{Map};
    use starknet::{ContractAddress, get_caller_address};
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