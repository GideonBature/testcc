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