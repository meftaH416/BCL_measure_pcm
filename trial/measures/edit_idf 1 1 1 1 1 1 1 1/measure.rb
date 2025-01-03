# *******************************************************************************
# OpenStudio(R), Copyright (c) Alliance for Sustainable Energy, LLC.
# See also https://openstudio.net/license
# *******************************************************************************

# see the URL below for information on how to write OpenStudio measures
# http://openstudio.nrel.gov/openstudio-measure-writing-guide

# start the measure
class EditIdf < OpenStudio::Measure::EnergyPlusMeasure
  # human readable name
  def name
    return "Edit idf"
  end
  # human readable description
  def description
    return "Change time step"
  end
  # human readable description of modeling approach
  def modeler_description
    return "Will change time step"
  end


  # define the arguments that the user will input
  def arguments(workspace)
    args = OpenStudio::Measure::OSArgumentVector.new

    # the name of the zone to receive air
    time_step = OpenStudio::Measure::OSArgument.makeStringArgument('time_step', true)
    time_step.setDisplayName('Time step in an hour')
    args << time_step

    # PCM Material Arguments
    pcm_index = OpenStudio::Measure::OSArgument.makeIntegerArgument('pcm_index', true)
    pcm_index.setDisplayName('PCM Layer Position')
    pcm_index.setDefaultValue(0)
    args << pcm_index

    pcm_name = OpenStudio::Measure::OSArgument.makeStringArgument('pcm_name', true)
    pcm_name.setDisplayName('PCM Layer Name')
    pcm_name.setDefaultValue('PCMBoard')
    args << pcm_name
  
    pcm_thickness = OpenStudio::Measure::OSArgument.makeDoubleArgument('pcm_thickness', true)
    pcm_thickness.setDisplayName('PCM Layer Thickness (m)')
    pcm_thickness.setDefaultValue(0.01905)
    args << pcm_thickness
  
    pcm_cond = OpenStudio::Measure::OSArgument.makeDoubleArgument('pcm_cond', true)
    pcm_cond.setDisplayName('PCM Conductivity (W/m-k)')
    pcm_cond.setDefaultValue(0.7264224)
    args << pcm_cond
  
    pcm_den = OpenStudio::Measure::OSArgument.makeDoubleArgument('pcm_den', true)
    pcm_den.setDisplayName('PCM Density (kg/m3)')
    pcm_den.setDefaultValue(1601.846)
    args << pcm_den
  
    pcm_sp_heat = OpenStudio::Measure::OSArgument.makeDoubleArgument('pcm_sp_heat', true)
    pcm_sp_heat.setDisplayName('PCM Specific Heat (J/kg-k)')
    pcm_sp_heat.setDefaultValue(836.8000)
    args << pcm_sp_heat

    pcm_rough = OpenStudio::Measure::OSArgument.makeStringArgument('pcm_rough', false)
    pcm_rough.setDisplayName('Roughness')
    pcm_rough.setDefaultValue('Smooth')
    args << pcm_rough
  
    pcm_abs = OpenStudio::Measure::OSArgument.makeDoubleArgument('pcm_abs', false)
    pcm_abs.setDisplayName('PCM Thermal Absorptance')
    pcm_abs.setDefaultValue(0.9000)
    args << pcm_abs
  
    pcm_sol_abs = OpenStudio::Measure::OSArgument.makeDoubleArgument('pcm_sol_abs', false)
    pcm_sol_abs.setDisplayName('PCM Solar Absorptance')
    pcm_sol_abs.setDefaultValue(0.9200)
    args << pcm_sol_abs
  
    pcm_vis_abs = OpenStudio::Measure::OSArgument.makeDoubleArgument('pcm_vis_abs', false)
    pcm_vis_abs.setDisplayName('PCM Visible Absorptance')
    pcm_vis_abs.setDefaultValue(0.9200)
    args << pcm_vis_abs

    # PCM Phase Change Temperature and Enthalpy Arguments

    temp_coeff = OpenStudio::Measure::OSArgument.makeDoubleArgument('temp_coeff', false)
    temp_coeff.setDisplayName('Temperature coefficient')
    temp_coeff.setDefaultValue(0.01)
    args << temp_coeff

    temp1 = OpenStudio::Measure::OSArgument.makeDoubleArgument('temp1', true)
    temp1.setDisplayName('Temperature 1 (°C)')
    temp1.setDefaultValue(-20.0)
    args << temp1
  
    enthalpy1 = OpenStudio::Measure::OSArgument.makeDoubleArgument('enthalpy1', true)
    enthalpy1.setDisplayName('Enthalpy 1 (J/kg)')
    enthalpy1.setDefaultValue(0.0)
    args << enthalpy1
  
    temp2 = OpenStudio::Measure::OSArgument.makeDoubleArgument('temp2', true)
    temp2.setDisplayName('Temperature 2 (°C)')
    temp2.setDefaultValue(20.0)
    args << temp2
  
    enthalpy2 = OpenStudio::Measure::OSArgument.makeDoubleArgument('enthalpy2', true)
    enthalpy2.setDisplayName('Enthalpy 2 (J/kg)')
    enthalpy2.setDefaultValue(33400)
    args << enthalpy2
  
    temp3 = OpenStudio::Measure::OSArgument.makeDoubleArgument('temp3', true)
    temp3.setDisplayName('Temperature 3 (°C)')
    temp3.setDefaultValue(20.5)
    args << temp3
  
    enthalpy3 = OpenStudio::Measure::OSArgument.makeDoubleArgument('enthalpy3', true)
    enthalpy3.setDisplayName('Enthalpy 3 (J/kg)')
    enthalpy3.setDefaultValue(70000)
    args << enthalpy3
  
    temp4 = OpenStudio::Measure::OSArgument.makeDoubleArgument('temp4', true)
    temp4.setDisplayName('Temperature 4 (°C)')
    temp4.setDefaultValue(100.0)
    args << temp4
  
    enthalpy4 = OpenStudio::Measure::OSArgument.makeDoubleArgument('enthalpy4', true)
    enthalpy4.setDisplayName('Enthalpy 4 (J/kg)')
    enthalpy4.setDefaultValue(137000)
    args << enthalpy4


    return args
  end


  # define what happens when the measure is run
  def run(workspace, runner, user_arguments)
    super(workspace, runner, user_arguments)

    # use the built-in error checking
    if !runner.validateUserArguments(arguments(workspace), user_arguments)
      return false
    end

    # assign the user inputs to variables
    time_step = runner.getStringArgumentValue('time_step', user_arguments)

    pcm_name = runner.getStringArgumentValue('pcm_name', user_arguments)
    pcm_thickness = runner.getDoubleArgumentValue('pcm_thickness', user_arguments)
    pcm_cond = runner.getDoubleArgumentValue('pcm_cond', user_arguments)
    pcm_den = runner.getDoubleArgumentValue('pcm_den', user_arguments)
    pcm_sp_heat = runner.getDoubleArgumentValue('pcm_sp_heat', user_arguments)
    pcm_rough = runner.getStringArgumentValue('pcm_rough', user_arguments)
    pcm_abs = runner.getDoubleArgumentValue('pcm_abs', user_arguments)
    pcm_sol_abs = runner.getDoubleArgumentValue('pcm_sol_abs', user_arguments)
    pcm_vis_abs = runner.getDoubleArgumentValue('pcm_vis_abs', user_arguments)

    temp_coeff = runner.getDoubleArgumentValue('temp_coeff', user_arguments)
    temp1 = runner.getDoubleArgumentValue('temp1', user_arguments)
    enthalpy1 = runner.getDoubleArgumentValue('enthalpy1', user_arguments)
    temp2 = runner.getDoubleArgumentValue('temp2', user_arguments)
    enthalpy2 = runner.getDoubleArgumentValue('enthalpy2', user_arguments)
    temp3 = runner.getDoubleArgumentValue('temp3', user_arguments)
    enthalpy3 = runner.getDoubleArgumentValue('enthalpy3', user_arguments)
    temp4 = runner.getDoubleArgumentValue('temp4', user_arguments)
    enthalpy4 = runner.getDoubleArgumentValue('enthalpy4', user_arguments)


    # reporting initial condition of model
    ts = workspace.getObjectsByType('Timestep'.to_IddObjectType).first
    ts = ts.getString(0).to_s
    runner.registerInitialCondition("The initial timestep is #{ts}")

    ts = workspace.getObjectsByType('Timestep'.to_IddObjectType).first
    unless ts.getString(0).to_s <= 20.to_s
      ts.setString(0, time_step)
      runner.registerInfo('Timestep = 20')
    end
    runner.registerFinalCondition("The final timestep is #{ts}")

    # HeatBalanceAlgorithm
    hba = workspace.getObjectsByType('HeatBalanceAlgorithm'.to_IddObjectType).first
    unless hba.getString(0).to_s == 'ConductionFiniteDifference'
      hba.setString(0, 'ConductionFiniteDifference')
      runner.registerInfo('HeatBalanceAlgorithm = ConductionFiniteDifference')
    end

    # array to hold new IDF objects
    string_objects1 = []
    
    # Construct the Material IDF object
      string_objects1 << "
 
      Material,
        #{pcm_name},                		      !- Name
        #{pcm_rough},                  		!- Roughness
        #{pcm_thickness},                     	!- Thickness {m}
        #{pcm_cond},                      		!- Conductivity {W/m-K}
        #{pcm_den},                      		!- Density {kg/m3}
        #{pcm_sp_heat},                      	!- Specific Heat {J/kg-K}
        #{pcm_abs},               			!- Thermal Absorptance
        #{pcm_sol_abs},               		!- Solar Absorptance
        #{pcm_vis_abs};               		!- Visible Absorptance
        "

    # add all of the strings to workspace to create IDF objects
    string_objects1.each do |string_object|
      idfObject = OpenStudio::IdfObject::load(string_object)
      object = idfObject.get
      wsObject = workspace.addObject(object)
    end    

    # array to hold new IDF objects
    string_objects2 = []

    # Construct the MaterialProperty:PhaseChange IDF object
    string_objects2 << "

    MaterialProperty:PhaseChange,
        #{pcm_name},                		       !- Name
        #{temp_coeff},                 	!- Temperature coefficient, thermal conductivity (W/m K2)
        #{temp1},                      		!- Temperature 1, C
        #{enthalpy1},                      	       !- Enthalpy 1, (J/kg)
        #{temp2},                      		!- Temperature 2, C
        #{enthalpy2},                      	       !- Enthalpy 2, (J/kg)
        #{temp3},                      		!- Temperature 3, C
        #{enthalpy3},                      	       !- Enthalpy 3, (J/kg)
        #{temp4},                      		!- Temperature 4, C
        #{enthalpy4};                      	       !- Enthalpy 4, (J/kg)

    "
    # add all of the strings to workspace to create IDF objects
    string_objects2.each do |string_object|
      idfObject = OpenStudio::IdfObject::load(string_object)
      object = idfObject.get
      wsObject = workspace.addObject(object)
    end

    
  end
end

# register the measure to be used by the application
EditIdf.new.registerWithApplication
