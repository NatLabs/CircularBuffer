let Package = { 
    name : Text, 
    version : Text, 
    repo : Text, 
    dependencies : List Text 
}

-- This is where you can add your own packages to the package-set
let packages = [
    {
        name = "base",
        version = "moc-0.8.1",
        repo = "https://github.com/dfinity/motoko-base",
        dependencies = [ ] : List Text
    }
] : List Package

in packages
