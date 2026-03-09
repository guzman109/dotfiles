function mac_update --description "Function to update all packages installed"
    printf "Updating Brew Packages.\n"
    command brew upgrade
    printf "Updating VCPKG.\n"
    command git -C ~/.vcpkg pull && ~/.vcpkg/bootstrap-vcpkg.sh
    printf "Updating Cargo Packages.\n"
    command cargo install-update -a
    printf "Updating Mas(App Store) Packages.\n"
    command mas update
  printf "Done!"
end
