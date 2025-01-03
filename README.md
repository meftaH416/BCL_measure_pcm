I have created an EnergyPlus Measure that can add a material with phase change property and edit idf to run the simulation. 
The measure will create material, add it to a specific user defined layer of construction, replace heatbalance algorithm to ConductionFiniteDifference 
and will input Timestep (recommended <=20).
