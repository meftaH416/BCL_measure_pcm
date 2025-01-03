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
    string_objects = []
    
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
    end

    # add all of the strings to workspace to create IDF objects
    string_objects1.each do |string_object|
      idfObject = OpenStudio::IdfObject::load(string_object)
      object = idfObject.get
      wsObject = workspace.addObject(object)
    end    

    
  end
end

# register the measure to be used by the application
EditIdf.new.registerWithApplication
