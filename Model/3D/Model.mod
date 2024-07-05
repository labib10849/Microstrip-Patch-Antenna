'# MWS Version: Version 2018.0 - Oct 26 2017 - ACIS 27.0.2 -

'# length = mm
'# frequency = GHz
'# time = ns
'# frequency range: fmin = 25 fmax = 31
'# created = '[VERSION]2018.0|27.0.2|20171026[/VERSION]


'@ use template: Unique_Design_1.cfg

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
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
'set the frequency range
Solver.FrequencyRange "8", "12"
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

'@ new component: component1

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
Component.New "component1"

'@ define brick: component1:Ground

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Brick
     .Reset 
     .Name "Ground" 
     .Component "component1" 
     .Material "PEC" 
     .Xrange "-Wg/2", "Wg/2" 
     .Yrange "-Ls/2", "-Ls/2+Lg" 
     .Zrange "-Ht", "0" 
     .Create
End With

'@ define material colour: PEC

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Material 
     .Name "PEC"
     .Folder ""
     .Colour "1", "1", "0" 
     .Wireframe "False" 
     .Reflection "True" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .ChangeColour 
End With

'@ define material: Rogers RT5880 (lossy)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Material
     .Reset
     .Name "Rogers RT5880 (lossy)"
     .Folder ""
.FrqType "all"
.Type "Normal"
.SetMaterialUnit "GHz", "mm"
.Epsilon "2.2"
.Mu "1.0"
.Kappa "0.0"
.TanD "0.0009"
.TanDFreq "10.0"
.TanDGiven "True"
.TanDModel "ConstTanD"
.KappaM "0.0"
.TanDM "0.0"
.TanDMFreq "0.0"
.TanDMGiven "False"
.TanDMModel "ConstKappa"
.DispModelEps "None"
.DispModelMu "None"
.DispersiveFittingSchemeEps "General 1st"
.DispersiveFittingSchemeMu "General 1st"
.UseGeneralDispersionEps "False"
.UseGeneralDispersionMu "False"
.Rho "0.0"
.ThermalType "Normal"
.ThermalConductivity "0.20"
.SetActiveMaterial "all"
.Colour "0.94", "0.82", "0.76"
.Wireframe "False"
.Transparency "0"
.Create
End With

'@ define brick: component1:Substrate

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Brick
     .Reset 
     .Name "Substrate" 
     .Component "component1" 
     .Material "Rogers RT5880 (lossy)" 
     .Xrange "-Ws/2", "Ws/2" 
     .Yrange "-Ls/2", "Ls/2" 
     .Zrange "0", "Hs" 
     .Create
End With

'@ define material colour: Rogers RT5880 (lossy)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Material 
     .Name "Rogers RT5880 (lossy)"
     .Folder ""
     .Colour "0.501961", "0.501961", "0.501961" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .ChangeColour 
End With

'@ define brick: component1:Patch

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Brick
     .Reset 
     .Name "Patch" 
     .Component "component1" 
     .Material "PEC" 
     .Xrange "-Wp/2", "Wp/2" 
     .Yrange "-Lp/2", "Lp/2" 
     .Zrange "Hs", "Hs+Ht" 
     .Create
End With

'@ define brick: component1:Feedline

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Brick
     .Reset 
     .Name "Feedline" 
     .Component "component1" 
     .Material "PEC" 
     .Xrange "-Wf/2", "Wf/2" 
     .Yrange "-Ls/2", "-Lp/2" 
     .Zrange "Hs", "Hs+Ht" 
     .Create
End With

'@ define brick: component1:Inset

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Brick
     .Reset 
     .Name "Inset" 
     .Component "component1" 
     .Material "PEC" 
     .Xrange "Wf/2", "Wf/2+Wi" 
     .Yrange "-Lp/2", "-Lp/2+Li" 
     .Zrange "Hs", "Hs+Ht" 
     .Create
End With

'@ transform: mirror component1:Inset

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Transform 
     .Reset 
     .Name "component1:Inset" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .PlaneNormal "1", "0", "0" 
     .MultipleObjects "True" 
     .GroupObjects "True" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Mirror" 
End With

'@ boolean subtract shapes: component1:Patch, component1:Inset

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
Solid.Subtract "component1:Patch", "component1:Inset"

'@ boolean add shapes: component1:Patch, component1:Feedline

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
Solid.Add "component1:Patch", "component1:Feedline"

'@ pick face

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
Pick.PickFaceFromId "component1:Patch", "3"

'@ define port:1

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
' Port constructed by macro Solver -> Ports -> Calculate port extension coefficient


With Port
  .Reset
  .PortNumber "1"
  .NumberOfModes "1"
  .AdjustPolarization False
  .PolarizationAngle "0.0"
  .ReferencePlaneDistance "0"
  .TextSize "50"
  .Coordinates "Picks"
  .Orientation "Positive"
  .PortOnBound "True"
  .ClipPickedPortToBound "False"
  .XrangeAdd "0.5*9.9", "0.5*9.9"
  .YrangeAdd "0", "0"
  .ZrangeAdd "0.5", "0.5*9.9"
  .Shield "PEC"
  .SingleEnded "False"
  .Create
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Efield"
          .Dimension "Volume" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-9.5", "9.5", "-9.5", "9.5", "-0.035", "5.485" 
          .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
          .CreateUsingLinearSamples "8", "12", "50"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Hfield"
          .Dimension "Volume" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-9.5", "9.5", "-9.5", "9.5", "-0.035", "5.485" 
          .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
          .CreateUsingLinearSamples "8", "12", "50"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Farfield"
          .ExportFarfieldSource "False" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-9.5", "9.5", "-9.5", "9.5", "-0.035", "5.485" 
          .SetSubvolumeOffset "10", "10", "10", "10", "10", "10" 
          .SetSubvolumeOffsetType "FractionOfWavelength" 
          .CreateUsingLinearSamples "8", "12", "50"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Surfacecurrent"
          .Dimension "Volume" 
          .CreateUsingLinearSamples "8", "12", "50"
End With

'@ define time domain solver parameters

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
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

'@ delete port: port1

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
Port.Delete "1"

'@ define brick: component1:slot

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Brick
     .Reset 
     .Name "slot" 
     .Component "component1" 
     .Material "PEC" 
     .Xrange "2", "4.5" 
     .Yrange "3", "3.3" 
     .Zrange "Hs", "Hs+Ht" 
     .Create
End With

'@ define brick: component1:solid1

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Brick
     .Reset 
     .Name "solid1" 
     .Component "component1" 
     .Material "PEC" 
     .Xrange "2", "2.35" 
     .Yrange "3", "4.45" 
     .Zrange "Hs", "Hs+Ht" 
     .Create
End With

'@ transform: translate component1:solid1

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1" 
     .Vector "1.075", "0", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "2" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate component1:solid1_1

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1_1" 
     .Vector "0", "-1.15", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Translate" 
End With

'@ boolean add shapes: component1:slot, component1:solid1

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
Solid.Add "component1:slot", "component1:solid1"

'@ boolean add shapes: component1:slot, component1:solid1_1

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
Solid.Add "component1:slot", "component1:solid1_1"

'@ boolean add shapes: component1:slot, component1:solid1_1_1

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
Solid.Add "component1:slot", "component1:solid1_1_1"

'@ boolean add shapes: component1:slot, component1:solid1_2

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
Solid.Add "component1:slot", "component1:solid1_2"

'@ boolean subtract shapes: component1:Patch, component1:slot

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
Solid.Subtract "component1:Patch", "component1:slot"

'@ pick face

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
Pick.PickFaceFromId "component1:Patch", "44"

'@ define frequency range

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
Solver.FrequencyRange "25", "31"

'@ define port:1

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
' Port constructed by macro Solver -> Ports -> Calculate port extension coefficient


With Port
  .Reset
  .PortNumber "1"
  .NumberOfModes "1"
  .AdjustPolarization False
  .PolarizationAngle "0.0"
  .ReferencePlaneDistance "0"
  .TextSize "50"
  .Coordinates "Picks"
  .Orientation "Positive"
  .PortOnBound "True"
  .ClipPickedPortToBound "False"
  .XrangeAdd "0.5*5.73", "0.5*5.73"
  .YrangeAdd "0", "0"
  .ZrangeAdd "0.5", "0.5*5.73"
  .Shield "PEC"
  .SingleEnded "False"
  .Create
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Efield"
          .Dimension "Volume" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-9.5", "9.5", "-9.5", "9.5", "-0.035", "3.4" 
          .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
          .CreateUsingLinearSamples "25", "31", "50"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Hfield"
          .Dimension "Volume" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-9.5", "9.5", "-9.5", "9.5", "-0.035", "3.4" 
          .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
          .CreateUsingLinearSamples "25", "31", "50"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Farfield"
          .ExportFarfieldSource "False" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-9.5", "9.5", "-9.5", "9.5", "-0.035", "3.4" 
          .SetSubvolumeOffset "10", "10", "10", "10", "10", "10" 
          .SetSubvolumeOffsetType "FractionOfWavelength" 
          .CreateUsingLinearSamples "25", "31", "50"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Surfacecurrent"
          .Dimension "Volume" 
          .CreateUsingLinearSamples "25", "31", "50"
End With

'@ define brick: component1:cutout

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Brick
     .Reset 
     .Name "cutout" 
     .Component "component1" 
     .Material "PEC" 
     .Xrange "-Wp/2+1", "1.5" 
     .Yrange "Lp/2-2", "Lp/2" 
     .Zrange "Hs", "Hs+Ht" 
     .Create
End With

'@ boolean subtract shapes: component1:Patch, component1:cutout

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
Solid.Subtract "component1:Patch", "component1:cutout"

'@ delete port: port1

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
Port.Delete "1"

'@ pick face

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
Pick.PickFaceFromId "component1:Patch", "50"

'@ define port:1

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
' Port constructed by macro Solver -> Ports -> Calculate port extension coefficient


With Port
  .Reset
  .PortNumber "1"
  .NumberOfModes "1"
  .AdjustPolarization False
  .PolarizationAngle "0.0"
  .ReferencePlaneDistance "0"
  .TextSize "50"
  .Coordinates "Picks"
  .Orientation "Positive"
  .PortOnBound "True"
  .ClipPickedPortToBound "False"
  .XrangeAdd "0.5*5.73", "0.5*5.73"
  .YrangeAdd "0", "0"
  .ZrangeAdd "0.5", "0.5*5.73"
  .Shield "PEC"
  .SingleEnded "False"
  .Create
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Efield"
          .Dimension "Volume" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-9.5", "9.5", "-9.5", "9.5", "-0.035", "3.4" 
          .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
          .CreateUsingLinearSamples "25", "31", "50"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Hfield"
          .Dimension "Volume" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-9.5", "9.5", "-9.5", "9.5", "-0.035", "3.4" 
          .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
          .CreateUsingLinearSamples "25", "31", "50"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Farfield"
          .ExportFarfieldSource "False" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-9.5", "9.5", "-9.5", "9.5", "-0.035", "3.4" 
          .SetSubvolumeOffset "10", "10", "10", "10", "10", "10" 
          .SetSubvolumeOffsetType "FractionOfWavelength" 
          .CreateUsingLinearSamples "25", "31", "50"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Surfacecurrent"
          .Dimension "Volume" 
          .CreateUsingLinearSamples "25", "31", "50"
End With

'@ clear picks

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
Pick.ClearAllPicks

'@ delete port: port1

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
Port.Delete "1"

'@ pick face

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
Pick.PickFaceFromId "component1:Patch", "50"

'@ define port:1

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
' Port constructed by macro Solver -> Ports -> Calculate port extension coefficient


With Port
  .Reset
  .PortNumber "1"
  .NumberOfModes "1"
  .AdjustPolarization False
  .PolarizationAngle "0.0"
  .ReferencePlaneDistance "0"
  .TextSize "50"
  .Coordinates "Picks"
  .Orientation "Positive"
  .PortOnBound "True"
  .ClipPickedPortToBound "False"
  .XrangeAdd "0.5*5.37", "0.5*5.37"
  .YrangeAdd "0", "0"
  .ZrangeAdd "0.5", "0.5*5.37"
  .Shield "PEC"
  .SingleEnded "False"
  .Create
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Efield"
          .Dimension "Volume" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-9.5", "9.5", "-9.5", "9.5", "-0.035", "3.22" 
          .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
          .CreateUsingLinearSamples "25", "31", "50"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Hfield"
          .Dimension "Volume" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-9.5", "9.5", "-9.5", "9.5", "-0.035", "3.22" 
          .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
          .CreateUsingLinearSamples "25", "31", "50"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Farfield"
          .ExportFarfieldSource "False" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-9.5", "9.5", "-9.5", "9.5", "-0.035", "3.22" 
          .SetSubvolumeOffset "10", "10", "10", "10", "10", "10" 
          .SetSubvolumeOffsetType "FractionOfWavelength" 
          .CreateUsingLinearSamples "25", "31", "50"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Surfacecurrent"
          .Dimension "Volume" 
          .CreateUsingLinearSamples "25", "31", "50"
End With

'@ delete port: port1

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
Port.Delete "1"

'@ pick face

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
Pick.PickFaceFromId "component1:Patch", "50"

'@ define port:1

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
' Port constructed by macro Solver -> Ports -> Calculate port extension coefficient


With Port
  .Reset
  .PortNumber "1"
  .NumberOfModes "1"
  .AdjustPolarization False
  .PolarizationAngle "0.0"
  .ReferencePlaneDistance "0"
  .TextSize "50"
  .Coordinates "Picks"
  .Orientation "Positive"
  .PortOnBound "True"
  .ClipPickedPortToBound "False"
  .XrangeAdd "0.5*6.04", "0.5*6.04"
  .YrangeAdd "0", "0"
  .ZrangeAdd "0.5", "0.5*6.04"
  .Shield "PEC"
  .SingleEnded "False"
  .Create
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Efield"
          .Dimension "Volume" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-9.5", "9.5", "-9.5", "9.5", "-0.035", "3.555" 
          .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
          .CreateUsingLinearSamples "25", "31", "50"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Hfield"
          .Dimension "Volume" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-9.5", "9.5", "-9.5", "9.5", "-0.035", "3.555" 
          .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
          .CreateUsingLinearSamples "25", "31", "50"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Farfield"
          .ExportFarfieldSource "False" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-9.5", "9.5", "-9.5", "9.5", "-0.035", "3.555" 
          .SetSubvolumeOffset "10", "10", "10", "10", "10", "10" 
          .SetSubvolumeOffsetType "FractionOfWavelength" 
          .CreateUsingLinearSamples "25", "31", "50"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Surfacecurrent"
          .Dimension "Volume" 
          .CreateUsingLinearSamples "25", "31", "50"
End With

'@ delete port: port1

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
Port.Delete "1"

'@ pick face

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
Pick.PickFaceFromId "component1:Patch", "50"

'@ define port:1

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
' Port constructed by macro Solver -> Ports -> Calculate port extension coefficient


With Port
  .Reset
  .PortNumber "1"
  .NumberOfModes "1"
  .AdjustPolarization False
  .PolarizationAngle "0.0"
  .ReferencePlaneDistance "0"
  .TextSize "50"
  .Coordinates "Picks"
  .Orientation "Positive"
  .PortOnBound "True"
  .ClipPickedPortToBound "False"
  .XrangeAdd "0.5*5.19", "0.5*5.19"
  .YrangeAdd "0", "0"
  .ZrangeAdd "0.5", "0.5*5.19"
  .Shield "PEC"
  .SingleEnded "False"
  .Create
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Efield"
          .Dimension "Volume" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-9.5", "9.5", "-9.5", "9.5", "-0.035", "3.13" 
          .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
          .CreateUsingLinearSamples "25", "31", "50"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Hfield"
          .Dimension "Volume" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-9.5", "9.5", "-9.5", "9.5", "-0.035", "3.13" 
          .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
          .CreateUsingLinearSamples "25", "31", "50"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Farfield"
          .ExportFarfieldSource "False" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-9.5", "9.5", "-9.5", "9.5", "-0.035", "3.13" 
          .SetSubvolumeOffset "10", "10", "10", "10", "10", "10" 
          .SetSubvolumeOffsetType "FractionOfWavelength" 
          .CreateUsingLinearSamples "25", "31", "50"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Surfacecurrent"
          .Dimension "Volume" 
          .CreateUsingLinearSamples "25", "31", "50"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Efield"
          .Dimension "Volume" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-9.5", "9.5", "-9.5", "9.5", "-0.035", "3.13" 
          .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
          .CreateUsingLinearSamples "25", "31", "50"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Hfield"
          .Dimension "Volume" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-9.5", "9.5", "-9.5", "9.5", "-0.035", "3.13" 
          .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
          .CreateUsingLinearSamples "25", "31", "50"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Farfield"
          .ExportFarfieldSource "False" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-9.5", "9.5", "-9.5", "9.5", "-0.035", "3.13" 
          .SetSubvolumeOffset "10", "10", "10", "10", "10", "10" 
          .SetSubvolumeOffsetType "FractionOfWavelength" 
          .CreateUsingLinearSamples "25", "31", "50"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Surfacecurrent"
          .Dimension "Volume" 
          .CreateUsingLinearSamples "25", "31", "50"
End With

'@ delete port: port1

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
Port.Delete "1"

'@ pick face

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
Pick.PickFaceFromId "component1:Patch", "50"

'@ define port:1

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
' Port constructed by macro Solver -> Ports -> Calculate port extension coefficient


With Port
  .Reset
  .PortNumber "1"
  .NumberOfModes "1"
  .AdjustPolarization False
  .PolarizationAngle "0.0"
  .ReferencePlaneDistance "0"
  .TextSize "50"
  .Coordinates "Picks"
  .Orientation "Positive"
  .PortOnBound "True"
  .ClipPickedPortToBound "False"
  .XrangeAdd "0.5*5.19", "0.5*5.19"
  .YrangeAdd "0", "0"
  .ZrangeAdd "0.5", "0.5*5.19"
  .Shield "PEC"
  .SingleEnded "False"
  .Create
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Efield"
          .Dimension "Volume" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-8", "8", "-8", "8", "-0.035", "3.13" 
          .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
          .CreateUsingLinearSamples "25", "31", "50"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Hfield"
          .Dimension "Volume" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-8", "8", "-8", "8", "-0.035", "3.13" 
          .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
          .CreateUsingLinearSamples "25", "31", "50"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Farfield"
          .ExportFarfieldSource "False" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-8", "8", "-8", "8", "-0.035", "3.13" 
          .SetSubvolumeOffset "10", "10", "10", "10", "10", "10" 
          .SetSubvolumeOffsetType "FractionOfWavelength" 
          .CreateUsingLinearSamples "25", "31", "50"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Surfacecurrent"
          .Dimension "Volume" 
          .CreateUsingLinearSamples "25", "31", "50"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Efield"
          .Dimension "Volume" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-8", "8", "-8", "8", "-0.035", "3.13" 
          .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
          .CreateUsingLinearSamples "25", "31", "50"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Hfield"
          .Dimension "Volume" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-8", "8", "-8", "8", "-0.035", "3.13" 
          .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
          .CreateUsingLinearSamples "25", "31", "50"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Farfield"
          .ExportFarfieldSource "False" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-8", "8", "-8", "8", "-0.035", "3.13" 
          .SetSubvolumeOffset "10", "10", "10", "10", "10", "10" 
          .SetSubvolumeOffsetType "FractionOfWavelength" 
          .CreateUsingLinearSamples "25", "31", "50"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Surfacecurrent"
          .Dimension "Volume" 
          .CreateUsingLinearSamples "25", "31", "50"
End With

'@ delete port: port1

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
Port.Delete "1"

'@ pick face

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
Pick.PickFaceFromId "component1:Patch", "50"

'@ define port:1

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
' Port constructed by macro Solver -> Ports -> Calculate port extension coefficient


With Port
  .Reset
  .PortNumber "1"
  .NumberOfModes "1"
  .AdjustPolarization False
  .PolarizationAngle "0.0"
  .ReferencePlaneDistance "0"
  .TextSize "50"
  .Coordinates "Picks"
  .Orientation "Positive"
  .PortOnBound "True"
  .ClipPickedPortToBound "False"
  .XrangeAdd "0.5*5.37", "0.5*5.37"
  .YrangeAdd "0", "0"
  .ZrangeAdd "0.5", "0.5*5.37"
  .Shield "PEC"
  .SingleEnded "False"
  .Create
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Efield"
          .Dimension "Volume" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-9", "9", "-8.5", "8.5", "-0.035", "3.22" 
          .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
          .CreateUsingLinearSamples "25", "31", "50"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Hfield"
          .Dimension "Volume" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-9", "9", "-8.5", "8.5", "-0.035", "3.22" 
          .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
          .CreateUsingLinearSamples "25", "31", "50"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Farfield"
          .ExportFarfieldSource "False" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-9", "9", "-8.5", "8.5", "-0.035", "3.22" 
          .SetSubvolumeOffset "10", "10", "10", "10", "10", "10" 
          .SetSubvolumeOffsetType "FractionOfWavelength" 
          .CreateUsingLinearSamples "25", "31", "50"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Surfacecurrent"
          .Dimension "Volume" 
          .CreateUsingLinearSamples "25", "31", "50"
End With

'@ delete port: port1

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
Port.Delete "1"

'@ pick face

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
Pick.PickFaceFromId "component1:Patch", "50"

'@ define port:1

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
' Port constructed by macro Solver -> Ports -> Calculate port extension coefficient


With Port
  .Reset
  .PortNumber "1"
  .NumberOfModes "1"
  .AdjustPolarization False
  .PolarizationAngle "0.0"
  .ReferencePlaneDistance "0"
  .TextSize "50"
  .Coordinates "Picks"
  .Orientation "Positive"
  .PortOnBound "True"
  .ClipPickedPortToBound "False"
  .XrangeAdd "0.5*5.37", "0.5*5.37"
  .YrangeAdd "0", "0"
  .ZrangeAdd "0.5", "0.5*5.37"
  .Shield "PEC"
  .SingleEnded "False"
  .Create
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Efield"
          .Dimension "Volume" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-7.5", "7.5", "-6.5", "6.5", "-0.035", "3.22" 
          .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
          .CreateUsingLinearSamples "25", "31", "50"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Hfield"
          .Dimension "Volume" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-7.5", "7.5", "-6.5", "6.5", "-0.035", "3.22" 
          .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
          .CreateUsingLinearSamples "25", "31", "50"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Farfield"
          .ExportFarfieldSource "False" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-7.5", "7.5", "-6.5", "6.5", "-0.035", "3.22" 
          .SetSubvolumeOffset "10", "10", "10", "10", "10", "10" 
          .SetSubvolumeOffsetType "FractionOfWavelength" 
          .CreateUsingLinearSamples "25", "31", "50"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Surfacecurrent"
          .Dimension "Volume" 
          .CreateUsingLinearSamples "25", "31", "50"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Efield"
          .Dimension "Volume" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-7.5", "7.5", "-6.5", "6.5", "-0.035", "3.22" 
          .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
          .CreateUsingLinearSamples "25", "31", "100"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Hfield"
          .Dimension "Volume" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-7.5", "7.5", "-6.5", "6.5", "-0.035", "3.22" 
          .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
          .CreateUsingLinearSamples "25", "31", "100"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Farfield"
          .ExportFarfieldSource "False" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-7.5", "7.5", "-6.5", "6.5", "-0.035", "3.22" 
          .SetSubvolumeOffset "10", "10", "10", "10", "10", "10" 
          .SetSubvolumeOffsetType "FractionOfWavelength" 
          .CreateUsingLinearSamples "25", "31", "100"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Surfacecurrent"
          .Dimension "Volume" 
          .CreateUsingLinearSamples "25", "31", "100"
End With

'@ delete port: port1

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
Port.Delete "1"

'@ pick face

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
Pick.PickFaceFromId "component1:Patch", "50"

'@ define port:1

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
' Port constructed by macro Solver -> Ports -> Calculate port extension coefficient


With Port
  .Reset
  .PortNumber "1"
  .NumberOfModes "1"
  .AdjustPolarization False
  .PolarizationAngle "0.0"
  .ReferencePlaneDistance "0"
  .TextSize "50"
  .Coordinates "Picks"
  .Orientation "Positive"
  .PortOnBound "True"
  .ClipPickedPortToBound "False"
  .XrangeAdd "0.5*5.37", "0.5*5.37"
  .YrangeAdd "0", "0"
  .ZrangeAdd "0.5", "0.5*5.37"
  .Shield "PEC"
  .SingleEnded "False"
  .Create
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Efield"
          .Dimension "Volume" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-9.5", "9.5", "-9.5", "9.5", "-0.035", "3.22" 
          .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
          .CreateUsingLinearSamples "25", "31", "100"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Hfield"
          .Dimension "Volume" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-9.5", "9.5", "-9.5", "9.5", "-0.035", "3.22" 
          .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
          .CreateUsingLinearSamples "25", "31", "100"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Farfield"
          .ExportFarfieldSource "False" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-9.5", "9.5", "-9.5", "9.5", "-0.035", "3.22" 
          .SetSubvolumeOffset "10", "10", "10", "10", "10", "10" 
          .SetSubvolumeOffsetType "FractionOfWavelength" 
          .CreateUsingLinearSamples "25", "31", "100"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Surfacecurrent"
          .Dimension "Volume" 
          .CreateUsingLinearSamples "25", "31", "100"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Efield"
          .Dimension "Volume" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-9.5", "9.5", "-9.5", "9.5", "-0.035", "3.22" 
          .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
          .CreateUsingLinearSamples "25", "31", "100"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Hfield"
          .Dimension "Volume" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-9.5", "9.5", "-9.5", "9.5", "-0.035", "3.22" 
          .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
          .CreateUsingLinearSamples "25", "31", "100"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Farfield"
          .ExportFarfieldSource "False" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-9.5", "9.5", "-9.5", "9.5", "-0.035", "3.22" 
          .SetSubvolumeOffset "10", "10", "10", "10", "10", "10" 
          .SetSubvolumeOffsetType "FractionOfWavelength" 
          .CreateUsingLinearSamples "25", "31", "100"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Surfacecurrent"
          .Dimension "Volume" 
          .CreateUsingLinearSamples "25", "31", "100"
End With

'@ delete port: port1

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
Port.Delete "1"

'@ pick face

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
Pick.PickFaceFromId "component1:Patch", "50"

'@ define port:1

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
' Port constructed by macro Solver -> Ports -> Calculate port extension coefficient


With Port
  .Reset
  .PortNumber "1"
  .NumberOfModes "1"
  .AdjustPolarization False
  .PolarizationAngle "0.0"
  .ReferencePlaneDistance "0"
  .TextSize "50"
  .Coordinates "Picks"
  .Orientation "Positive"
  .PortOnBound "True"
  .ClipPickedPortToBound "False"
  .XrangeAdd "0.5*4.65", "0.5*4.65"
  .YrangeAdd "0", "0"
  .ZrangeAdd "0.5", "0.5*4.65"
  .Shield "PEC"
  .SingleEnded "False"
  .Create
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Efield"
          .Dimension "Volume" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-9.5", "9.5", "-9.5", "9.5", "-0.035", "2.86" 
          .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
          .CreateUsingLinearSamples "25", "31", "100"
End With

'@ set parametersweep options

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With ParameterSweep
    .SetSimulationType "Transient" 
End With

'@ add parsweep sequence: Sequence 1

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With ParameterSweep
     .AddSequence "Sequence 1" 
End With

'@ add parsweep parameter: Sequence 1:Wf

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With ParameterSweep
     .AddParameter_Stepwidth "Sequence 1", "Wf", "0.4", "1.6", "0.1" 
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Efield"
          .Dimension "Volume" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-12.176718375", "12.176718375", "-12.176718375", "12.176718375", "-2.711718375", "5.536718375" 
          .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
          .CreateUsingLinearSamples "25", "31", "100"
End With

'@ delete port: port1

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
Port.Delete "1"

'@ pick face

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
Pick.PickFaceFromId "component1:Patch", "50"

'@ define port:1

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
' Port constructed by macro Solver -> Ports -> Calculate port extension coefficient


With Port
  .Reset
  .PortNumber "1"
  .NumberOfModes "1"
  .AdjustPolarization False
  .PolarizationAngle "0.0"
  .ReferencePlaneDistance "0"
  .TextSize "50"
  .Coordinates "Picks"
  .Orientation "Positive"
  .PortOnBound "True"
  .ClipPickedPortToBound "False"
  .XrangeAdd "0.5*4.76", "0.5*4.76"
  .YrangeAdd "0", "0"
  .ZrangeAdd "0.5", "0.5*4.76"
  .Shield "PEC"
  .SingleEnded "False"
  .Create
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Efield"
          .Dimension "Volume" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-9.5", "9.5", "-9.5", "9.5", "-0.035", "2.915" 
          .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
          .CreateUsingLinearSamples "25", "31", "100"
End With

'@ delete port: port1

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
Port.Delete "1"

'@ pick face

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
Pick.PickFaceFromId "component1:Patch", "50"

'@ define port:1

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
' Port constructed by macro Solver -> Ports -> Calculate port extension coefficient


With Port
  .Reset
  .PortNumber "1"
  .NumberOfModes "1"
  .AdjustPolarization False
  .PolarizationAngle "0.0"
  .ReferencePlaneDistance "0"
  .TextSize "50"
  .Coordinates "Picks"
  .Orientation "Positive"
  .PortOnBound "True"
  .ClipPickedPortToBound "False"
  .XrangeAdd "0.5*4.76", "0.5*4.76"
  .YrangeAdd "0", "0"
  .ZrangeAdd "0.5", "0.5*4.76"
  .Shield "PEC"
  .SingleEnded "False"
  .Create
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Efield"
          .Dimension "Volume" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-9.5", "9.5", "-9.5", "9.5", "-0.035", "2.915" 
          .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
          .CreateUsingLinearSamples "25", "31", "100"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Efield"
          .Dimension "Volume" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-9.5", "9.5", "-9.5", "9.5", "-0.035", "2.915" 
          .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
          .CreateUsingLinearSamples "25", "31", "100"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Efield"
          .Dimension "Volume" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-9.5", "9.5", "-9.5", "9.5", "-0.035", "2.915" 
          .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
          .CreateUsingLinearSamples "25", "31", "100"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Efield"
          .Dimension "Volume" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-9.5", "9.5", "-9.5", "9.5", "-0.035", "2.915" 
          .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
          .CreateUsingLinearSamples "25", "31", "100"
End With

'@ farfield plot options

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
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
     .SetPlotMode "Directivity" 
     .Distance "1" 
     .UseFarfieldApproximation "True" 
     .SetScaleLinear "False" 
     .SetLogRange "40" 
     .SetLogNorm "0" 
     .DBUnit "0" 
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

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Efield"
          .Dimension "Volume" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-9.5", "9.5", "-9.5", "9.5", "-0.035", "2.915" 
          .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
          .CreateUsingLinearSamples "25", "31", "100"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Hfield"
          .Dimension "Volume" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-9.5", "9.5", "-9.5", "9.5", "-0.035", "2.915" 
          .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
          .CreateUsingLinearSamples "25", "31", "100"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Farfield"
          .ExportFarfieldSource "False" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-9.5", "9.5", "-9.5", "9.5", "-0.035", "2.915" 
          .SetSubvolumeOffset "10", "10", "10", "10", "10", "10" 
          .SetSubvolumeOffsetType "FractionOfWavelength" 
          .CreateUsingLinearSamples "25", "31", "100"
End With

'@ define monitors (using linear samples)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor
          .Reset 
          .Domain "Frequency"
          .FieldType "Surfacecurrent"
          .Dimension "Volume" 
          .CreateUsingLinearSamples "25", "31", "100"
End With

'@ farfield plot options

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
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
     .SetFrequency "31" 
     .SetTime "0" 
     .SetColorByValue "True" 
     .DrawStepLines "False" 
     .DrawIsoLongitudeLatitudeLines "False" 
     .ShowStructure "False" 
     .ShowStructureProfile "False" 
     .SetStructureTransparent "False" 
     .SetFarfieldTransparent "False" 
     .SetSpecials "enablepolarextralines" 
     .SetPlotMode "Directivity" 
     .Distance "1" 
     .UseFarfieldApproximation "True" 
     .SetScaleLinear "False" 
     .SetLogRange "40" 
     .SetLogNorm "0" 
     .DBUnit "0" 
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


