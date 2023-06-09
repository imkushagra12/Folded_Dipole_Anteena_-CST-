'# MWS Version: Version 2019.0 - Sep 20 2018 - ACIS 28.0.2 -

'# length = mm
'# frequency = GHz
'# time = ns
'# frequency range: fmin = 1 fmax = 3
'# created = '[VERSION]2019.0|28.0.2|20180920[/VERSION]


'@ use template: Antenna - Planar_2.cfg

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
'set the units
With Units
    .Geometry "mm"
    .Frequency "GHz"
    .Voltage "V"
    .Resistance "Ohm"
    .Inductance "H"
    .TemperatureUnit  "Kelvin"
    .Time "ns"
    .Current "A"
    .Conductance "Siemens"
    .Capacitance "F"
End With
'----------------------------------------------------------------------------
Plot.DrawBox True
With Background
     .Type "Normal"
     .Epsilon "1.0"
     .Mu "1.0"
     .XminSpace "0.0"
     .XmaxSpace "0.0"
     .YminSpace "0.0"
     .YmaxSpace "0.0"
     .ZminSpace "0.0"
     .ZmaxSpace "0.0"
End With
With Boundary
     .Xmin "expanded open"
     .Xmax "expanded open"
     .Ymin "expanded open"
     .Ymax "expanded open"
     .Zmin "expanded open"
     .Zmax "expanded open"
     .Xsymmetry "none"
     .Ysymmetry "none"
     .Zsymmetry "none"
End With
' optimize mesh settings for planar structures
With Mesh
     .MergeThinPECLayerFixpoints "True"
     .RatioLimit "20"
     .AutomeshRefineAtPecLines "True", "6"
     .FPBAAvoidNonRegUnite "True"
     .ConsiderSpaceForLowerMeshLimit "False"
     .MinimumStepNumber "5"
     .AnisotropicCurvatureRefinement "True"
     .AnisotropicCurvatureRefinementFSM "True"
End With
With MeshSettings
     .SetMeshType "Hex"
     .Set "RatioLimitGeometry", "20"
     .Set "EdgeRefinementOn", "1"
     .Set "EdgeRefinementRatio", "6"
End With
With MeshSettings
     .SetMeshType "HexTLM"
     .Set "RatioLimitGeometry", "20"
End With
With MeshSettings
     .SetMeshType "Tet"
     .Set "VolMeshGradation", "1.5"
     .Set "SrfMeshGradation", "1.5"
End With
' change mesh adaption scheme to energy
' 		(planar structures tend to store high energy
'     	 locally at edges rather than globally in volume)
MeshAdaption3D.SetAdaptionStrategy "Energy"
' switch on FD-TET setting for accurate farfields
FDSolver.ExtrudeOpenBC "True"
PostProcess1D.ActivateOperation "vswr", "true"
PostProcess1D.ActivateOperation "yz-matrices", "true"
With FarfieldPlot
	.ClearCuts ' lateral=phi, polar=theta
	.AddCut "lateral", "0", "1"
	.AddCut "lateral", "90", "1"
	.AddCut "polar", "90", "1"
End With
'----------------------------------------------------------------------------
With MeshSettings
     .SetMeshType "Hex"
     .Set "Version", 1%
End With
With Mesh
     .MeshType "PBA"
End With
'set the solver type
ChangeSolverType("HF Time Domain")
'----------------------------------------------------------------------------

'@ define material: Copper (annealed)

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Material
     .Reset
     .Name "Copper (annealed)"
     .Folder ""
.FrqType "static"
.Type "Normal"
.SetMaterialUnit "Hz", "mm"
.Epsilon "1"
.Mu "1.0"
.Kappa "5.8e+007"
.TanD "0.0"
.TanDFreq "0.0"
.TanDGiven "False"
.TanDModel "ConstTanD"
.KappaM "0"
.TanDM "0.0"
.TanDMFreq "0.0"
.TanDMGiven "False"
.TanDMModel "ConstTanD"
.DispModelEps "None"
.DispModelMu "None"
.DispersiveFittingSchemeEps "Nth Order"
.DispersiveFittingSchemeMu "Nth Order"
.UseGeneralDispersionEps "False"
.UseGeneralDispersionMu "False"
.FrqType "all"
.Type "Lossy metal"
.SetMaterialUnit "GHz", "mm"
.Mu "1.0"
.Kappa "5.8e+007"
.Rho "8930.0"
.ThermalType "Normal"
.ThermalConductivity "401.0"
.HeatCapacity "0.39"
.MetabolicRate "0"
.BloodFlow "0"
.VoxelConvection "0"
.MechanicsType "Isotropic"
.YoungsModulus "120"
.PoissonsRatio "0.33"
.ThermalExpansionRate "17"
.Colour "1", "1", "0"
.Wireframe "False"
.Reflection "False"
.Allowoutline "True"
.Transparentoutline "False"
.Transparency "0"
.Create
End With

'@ new component: component1

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Component.New "component1"

'@ define cylinder: component1:dipole

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Cylinder 
     .Reset 
     .Name "dipole" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .OuterRadius "r" 
     .InnerRadius "0.0" 
     .Axis "z" 
     .Zrange "-h/2", "h/2" 
     .Xcenter "0" 
     .Ycenter "0" 
     .Segments "0" 
     .Create 
End With

'@ define brick: component1:brick

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Brick
     .Reset 
     .Name "brick" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "-s/2", "s/2" 
     .Yrange "-s/2", "s/2" 
     .Zrange "-s/2", "s/2" 
     .Create
End With

'@ boolean subtract shapes: component1:dipole, component1:brick

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Solid.Subtract "component1:dipole", "component1:brick"

'@ pick circle center point

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Pick.PickCirclecenterFromId "component1:dipole", "16"

'@ pick circle center point

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Pick.PickCirclecenterFromId "component1:dipole", "15"

'@ define discrete port: 1

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With DiscretePort 
     .Reset 
     .PortNumber "1" 
     .Type "SParameter" 
     .Label "" 
     .Folder "" 
     .Impedance "50.0" 
     .VoltagePortImpedance "0.0" 
     .Voltage "1.0" 
     .Current "1.0" 
     .SetP1 "True", "0", "0", "-3.35" 
     .SetP2 "True", "0", "0", "3.35" 
     .InvertDirection "False" 
     .LocalCoordinates "False" 
     .Monitor "True" 
     .Radius "0.0" 
     .Wire "" 
     .Position "end1" 
     .Create 
End With

'@ define cylinder: component1:reflector

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Cylinder 
     .Reset 
     .Name "reflector" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .OuterRadius "r" 
     .InnerRadius "0.0" 
     .Axis "z" 
     .Zrange "-h/2", "h/2" 
     .Xcenter "lam/4" 
     .Ycenter "0" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:bend

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Cylinder 
     .Reset 
     .Name "bend" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .OuterRadius "r" 
     .InnerRadius "0.0" 
     .Axis "x" 
     .Xrange "lam/8 - 0.2", "lam/8 + 0.2" 
     .Ycenter "0" 
     .Zcenter "lam/2.226" 
     .Segments "0" 
     .Create 
End With 


'@ pick face

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Pick.PickFaceFromId "component1:bend", "1"

'@ pick face

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Pick.PickFaceFromId "component1:dipole", "9"

'@ define loft: component1:solid1

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Loft 
     .Reset 
     .Name "solid1" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Tangency "0.15" 
     .Minimizetwist "true" 
     .CreateNew 
End With

'@ clear picks

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Pick.ClearAllPicks

'@ pick face

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Pick.PickFaceFromId "component1:reflector", "3"

'@ pick face

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Pick.PickFaceFromId "component1:bend", "3"

'@ define loft: component1:solid2

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Loft 
     .Reset 
     .Name "solid2" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Tangency "0.15" 
     .Minimizetwist "true" 
     .CreateNew 
End With

'@ define cylinder: component1:bend2

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Cylinder 
     .Reset 
     .Name "bend2" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .OuterRadius "r" 
     .InnerRadius "0.0" 
     .Axis "x" 
     .Xrange "lam/8 -0.2", "lam/8 + 0.2" 
     .Ycenter "0" 
     .Zcenter "-lam/2.226" 
     .Segments "0" 
     .Create 
End With 


'@ pick face

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Pick.PickFaceFromId "component1:reflector", "1"

'@ pick face

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Pick.PickFaceFromId "component1:bend2", "3"

'@ define loft: component1:solid3

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Loft 
     .Reset 
     .Name "solid3" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Tangency "0.15" 
     .Minimizetwist "true" 
     .CreateNew 
End With


'@ pick face

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Pick.PickFaceFromId "component1:dipole", "7"


'@ pick face

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Pick.PickFaceFromId "component1:bend2", "1"


'@ define loft: component1:solid4

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Loft 
     .Reset 
     .Name "solid4" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Tangency "0.15" 
     .Minimizetwist "true" 
     .CreateNew 
End With


'@ define frequency range

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Solver.FrequencyRange "1", "3"


'@ define monitor: e-field (f=1.8)

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Monitor 
     .Reset 
     .Name "e-field (f=1.8)" 
     .Dimension "Volume" 
     .Domain "Frequency" 
     .FieldType "Efield" 
     .MonitorValue "1.8" 
     .UseSubvolume "False" 
     .Coordinates "Structure" 
     .SetSubvolume "-1.25", "42.916666666667", "-1.25", "1.25", "-56.805555555556", "56.805555555556" 
     .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
     .SetSubvolumeInflateWithOffset "False" 
     .Create 
End With


'@ define monitor: h-field (f=1.8)

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Monitor 
     .Reset 
     .Name "h-field (f=1.8)" 
     .Dimension "Volume" 
     .Domain "Frequency" 
     .FieldType "Hfield" 
     .MonitorValue "1.8" 
     .UseSubvolume "False" 
     .Coordinates "Structure" 
     .SetSubvolume "-1.25", "42.916666666667", "-1.25", "1.25", "-56.805555555556", "56.805555555556" 
     .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
     .SetSubvolumeInflateWithOffset "False" 
     .Create 
End With


'@ define farfield monitor: farfield (f=1.8)

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Monitor 
     .Reset 
     .Name "farfield (f=1.8)" 
     .Domain "Frequency" 
     .FieldType "Farfield" 
     .MonitorValue "1.8" 
     .ExportFarfieldSource "False" 
     .UseSubvolume "False" 
     .Coordinates "Structure" 
     .SetSubvolume "-1.25", "42.916666666667", "-1.25", "1.25", "-56.805555555556", "56.805555555556" 
     .SetSubvolumeOffset "10", "10", "10", "10", "10", "10" 
     .SetSubvolumeInflateWithOffset "False" 
     .SetSubvolumeOffsetType "FractionOfWavelength" 
     .Create 
End With


'@ define time domain solver parameters

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Mesh.SetCreator "High Frequency" 
With Solver 
     .Method "Hexahedral"
     .CalculationType "TD-S"
     .StimulationPort "All"
     .StimulationMode "All"
     .SteadyStateLimit "-40"
     .MeshAdaption "False"
     .AutoNormImpedance "False"
     .NormingImpedance "50"
     .CalculateModesOnly "False"
     .SParaSymmetry "False"
     .StoreTDResultsInCache  "False"
     .FullDeembedding "False"
     .SuperimposePLWExcitation "False"
     .UseSensitivityAnalysis "False"
End With


'@ set PBA version

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Discretizer.PBAVersion "2018092019"


'@ farfield plot options

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With FarfieldPlot 
     .Plottype "3D" 
     .Vary "angle1" 
     .Theta "90" 
     .Phi "90" 
     .Step "5" 
     .Step2 "5" 
     .SetLockSteps "True" 
     .SetPlotRangeOnly "False" 
     .SetThetaStart "0" 
     .SetThetaEnd "180" 
     .SetPhiStart "0" 
     .SetPhiEnd "360" 
     .SetTheta360 "False" 
     .SymmetricRange "False" 
     .SetTimeDomainFF "False" 
     .SetFrequency "-1" 
     .SetTime "0" 
     .SetColorByValue "True" 
     .DrawStepLines "False" 
     .DrawIsoLongitudeLatitudeLines "False" 
     .ShowStructure "False" 
     .ShowStructureProfile "False" 
     .SetStructureTransparent "False" 
     .SetFarfieldTransparent "False" 
     .SetSpecials "enablepolarextralines" 
     .SetPlotMode "Gain" 
     .Distance "1" 
     .UseFarfieldApproximation "True" 
     .SetScaleLinear "False" 
     .SetLogRange "40" 
     .SetLogNorm "0" 
     .DBUnit "0" 
     .SetMaxReferenceMode "abs" 
     .EnableFixPlotMaximum "False" 
     .SetFixPlotMaximumValue "1" 
     .SetInverseAxialRatio "False" 
     .SetAxesType "user" 
     .SetAntennaType "unknown" 
     .Phistart "1.000000e+00", "0.000000e+00", "0.000000e+00" 
     .Thetastart "0.000000e+00", "0.000000e+00", "1.000000e+00" 
     .PolarizationVector "0.000000e+00", "1.000000e+00", "0.000000e+00" 
     .SetCoordinateSystemType "spherical" 
     .SetAutomaticCoordinateSystem "True" 
     .SetPolarizationType "Linear" 
     .SlantAngle 0.000000e+00 
     .Origin "bbox" 
     .Userorigin "0.000000e+00", "0.000000e+00", "0.000000e+00" 
     .SetUserDecouplingPlane "False" 
     .UseDecouplingPlane "False" 
     .DecouplingPlaneAxis "X" 
     .DecouplingPlanePosition "0.000000e+00" 
     .LossyGround "False" 
     .GroundEpsilon "1" 
     .GroundKappa "0" 
     .EnablePhaseCenterCalculation "False" 
     .SetPhaseCenterAngularLimit "3.000000e+01" 
     .SetPhaseCenterComponent "boresight" 
     .SetPhaseCenterPlane "both" 
     .ShowPhaseCenter "True" 
     .ClearCuts 
     .AddCut "lateral", "0", "1"  
     .AddCut "lateral", "90", "1"  
     .AddCut "polar", "90", "1"  
     .StoreSettings
End With 


