rm(list=ls())

library(readxl)
library(openxlsx) # Make sure this package is installed

# Input parameters 
# User selects the file via file.choose dialog
A <- file.choose()
Data <- read.csv(A, header = TRUE)

# Assuming the columns are named 'tau' for shear stress and 'v' for velocity
tau_values <- Data$tau
v_values <- Data$v

# Other parameters
rho <- 1000  # Fresh water density in kg/m^3
D <- 0.06733  # Hydraulic Pipe diameter in EFA meters
nu <- 1e-6   # Kinematic viscosity of water in m^2/s

solve_for_epsilon <- function(f, Re, D) {
  epsilon_start <- 1e-5
  epsilon_end <- 1e-3
  tol <- 1e-6
  
  while (epsilon_end - epsilon_start > tol) {
    epsilon_mid <- (epsilon_start + epsilon_end) / 2
    lhs <- 1 / sqrt(f)
    rhs <- -2 * log10((epsilon_mid / D) / 3.7 + 2.51 / (Re * sqrt(f)))
    
    if (lhs > rhs) {
      epsilon_end <- epsilon_mid
    } else {
      epsilon_start <- epsilon_mid
    }
  }
  
  return((epsilon_start + epsilon_end) / 2)
}

epsilon_values_mm <- numeric(length(tau_values)) 
# Initialize a vector to store epsilon values in mm

for (i in 1:length(tau_values)) {
  tau <- tau_values[i]
  v <- v_values[i]
  
  # Calculate Reynolds number for each set of tau and v
  Re <- v * D / nu
  
  f <- 8 * tau / (rho * v^2)
  
  epsilon_m <- solve_for_epsilon(f, Re, D) # epsilon in meters
  epsilon_mm <- epsilon_m * 1000 # Convert epsilon to millimeters
  epsilon_values_mm[i] <- epsilon_mm # Store the calculated epsilon in mm in the vector
  
  print(paste("For tau =", tau, "and v =", v, ", calculated surface roughness (epsilon) in mm is:", epsilon_mm))
}

# Append the epsilon values in mm as a new column to the data frame
Data$epsilon_mm <- epsilon_values_mm

# Write the modified data frame back to a new Excel file
write.xlsx(Data, "modified_data.xlsx", rowNames = FALSE)

# Show the updated data frame
print(Data)