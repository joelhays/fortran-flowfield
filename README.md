# Fortran Flow Fields

Flow Field exploration written in Fortran.

This intent of this project was to learn about modern fortran development
while exploring the concept of flow fields and doing something creative.

## Screenshots 
![Flow Field Animation](/screenshots/03.gif "Flow Field Animation")
![Flow Field Screenshot 1](/screenshots/01.png "Flow Field Screenshot 1")
![Flow Field Screenshot 2](/screenshots/02.png "Flow Field Screenshot 2")

## Getting Started

### Prerequisites

```sh
# install gfortran compiler
brew install gcc

# install opengl requirements for raylib
brew install mesa
brew install glfw

# install raylib
brew install raylib

# install fprettify for formatting fortran files
brew install fprettify

# install fortran package manager for build and dependency management
pip install fpm 

```

### Building and Running

Standard build:
```sh
# If you have make installed, then build and run the app via:
make run

# If not, build and run with fpm directly
fpm run \
	--flag "-fno-range-check" \
	--flag "-fbounds-check" \
	--flag "-L/opt/homebrew/Cellar/raylib/5.5/lib/" \
	--flag "-L/opt/homebrew/Cellar/glfw/3.4/lib/" \
	--flag "-L/opt/homebrew/Cellar/mesa/24.2.8/lib/"
```

Additional build options:
```sh
# Clean the workspace, deleting binaries, intermediate files, etc:
make clean

# Format all fortran files
make pretty
```

## Built With

* [Fortran](https://fortran-lang.org)
* [Fortran Package Manager](https://fpm.fortran-lang.org)
* [Raylib](https://www.raylib.com)
