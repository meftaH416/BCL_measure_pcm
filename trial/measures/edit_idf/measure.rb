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
    
  end
end

# register the measure to be used by the application
EditIdf.new.registerWithApplication
