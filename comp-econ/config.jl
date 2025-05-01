#=
This file is used to initialize the environment for the project.
It should be run just once, at the onset of the project. 
It specifies all packages that are required for the project.
=#

using Pkg

# Activate the current directory
Pkg.activate(".") 

# Add packages
Pkg.add(["FastGaussQuadrature", "Printf", "Random", "Statistics", "DataStructures"])

# Check package status
Pkg.status()

# Reproduce environment elsewhere
Pkg.instantiate()
