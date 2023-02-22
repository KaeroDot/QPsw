<?xml version='1.0' encoding='UTF-8'?>
<Project Type="Project" LVVersion="20008000">
	<Property Name="NI.LV.All.SourceOnly" Type="Bool">true</Property>
	<Property Name="NI.Project.Description" Type="Str"></Property>
	<Item Name="My Computer" Type="My Computer">
		<Property Name="server.app.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.control.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.tcp.enabled" Type="Bool">false</Property>
		<Property Name="server.tcp.port" Type="Int">0</Property>
		<Property Name="server.tcp.serviceName" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.tcp.serviceName.default" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.vi.callsEnabled" Type="Bool">true</Property>
		<Property Name="server.vi.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="specify.custom.address" Type="Bool">false</Property>
		<Item Name="external libraries" Type="Folder">
			<Item Name="externals needed for AWG" Type="Folder">
				<Item Name="3458A Sampling Rate.ctl" Type="VI" URL="../external libraries/externals needed for AWG/3458A Sampling Rate.ctl"/>
				<Item Name="ADC Trig Config.ctl" Type="VI" URL="../external libraries/externals needed for AWG/ADC Trig Config.ctl"/>
				<Item Name="ADC Trig Coupling.ctl" Type="VI" URL="../external libraries/externals needed for AWG/ADC Trig Coupling.ctl"/>
				<Item Name="ADC Trig Mode Source.ctl" Type="VI" URL="../external libraries/externals needed for AWG/ADC Trig Mode Source.ctl"/>
				<Item Name="ADC Trig Slope.ctl" Type="VI" URL="../external libraries/externals needed for AWG/ADC Trig Slope.ctl"/>
				<Item Name="GUI Set Error To String.vi" Type="VI" URL="../external libraries/externals needed for AWG/GUI Set Error To String.vi"/>
			</Item>
			<Item Name="AWG.lvlib" Type="Library" URL="../external libraries/AWG/AWG.lvlib"/>
			<Item Name="QuPMXdriver.lvlib" Type="Library" URL="../external libraries/QuPMXLabVIEWdriver/QuPMXdriver.lvlib"/>
			<Item Name="TWM client.lvlibp" Type="LVLibp" URL="../external libraries/TWM client.lvlibp">
				<Item Name="TWM Client Processing Setup.ctl" Type="VI" URL="../external libraries/TWM client.lvlibp/server/TWM client/TWM Client Processing Setup.ctl"/>
				<Item Name="TWM Client Quantity Record.ctl" Type="VI" URL="../external libraries/TWM client.lvlibp/server/TWM client/TWM Client Quantity Record.ctl"/>
				<Item Name="TWM Client Meas Setup.ctl" Type="VI" URL="../external libraries/TWM client.lvlibp/server/TWM client/TWM Client Meas Setup.ctl"/>
				<Item Name="TWM Client Meas Setup Trig.ctl" Type="VI" URL="../external libraries/TWM client.lvlibp/server/TWM client/TWM Client Meas Setup Trig.ctl"/>
				<Item Name="TWM Client Result Max Dim.ctl" Type="VI" URL="../external libraries/TWM client.lvlibp/server/TWM client/TWM Client Result Max Dim.ctl"/>
				<Item Name="TWM Client Transducer Correction Item.ctl" Type="VI" URL="../external libraries/TWM client.lvlibp/server/TWM client/TWM Client Transducer Correction Item.ctl"/>
				<Item Name="TWM Client Algorithm Info.ctl" Type="VI" URL="../external libraries/TWM client.lvlibp/server/TWM client/TWM Client Algorithm Info.ctl"/>
				<Item Name="TWM Client Result Info.ctl" Type="VI" URL="../external libraries/TWM client.lvlibp/server/TWM client/TWM Client Result Info.ctl"/>
				<Item Name="TWM Client Mux Path.ctl" Type="VI" URL="../external libraries/TWM client.lvlibp/server/TWM client/TWM Client Mux Path.ctl"/>
				<Item Name="TWM Client Cmd Get Result.vi" Type="VI" URL="../external libraries/TWM client.lvlibp/server/TWM client/TWM Client Cmd Get Result.vi"/>
				<Item Name="TWM Client Cmd Get Status.vi" Type="VI" URL="../external libraries/TWM client.lvlibp/server/TWM client/TWM Client Cmd Get Status.vi"/>
				<Item Name="TWM Client Cmd Get Algorithm Info.vi" Type="VI" URL="../external libraries/TWM client.lvlibp/server/TWM client/TWM Client Cmd Get Algorithm Info.vi"/>
				<Item Name="TWM Client Cmd Identify.vi" Type="VI" URL="../external libraries/TWM client.lvlibp/server/TWM client/TWM Client Cmd Identify.vi"/>
				<Item Name="TWM Client Cmd Restart.vi" Type="VI" URL="../external libraries/TWM client.lvlibp/server/TWM client/TWM Client Cmd Restart.vi"/>
				<Item Name="TWM Client Cmd Set Corrections.vi" Type="VI" URL="../external libraries/TWM client.lvlibp/server/TWM client/TWM Client Cmd Set Corrections.vi"/>
				<Item Name="TWM Client Cmd Set Measurement.vi" Type="VI" URL="../external libraries/TWM client.lvlibp/server/TWM client/TWM Client Cmd Set Measurement.vi"/>
				<Item Name="TWM Client Cmd Start.vi" Type="VI" URL="../external libraries/TWM client.lvlibp/server/TWM client/TWM Client Cmd Start.vi"/>
				<Item Name="TWM Client Cmd Stop.vi" Type="VI" URL="../external libraries/TWM client.lvlibp/server/TWM client/TWM Client Cmd Stop.vi"/>
				<Item Name="TWM Client Cmd Exec ADC Selfcalibration.vi" Type="VI" URL="../external libraries/TWM client.lvlibp/server/TWM client/TWM Client Cmd Exec ADC Selfcalibration.vi"/>
				<Item Name="TWM Client Cmd Get Versions.vi" Type="VI" URL="../external libraries/TWM client.lvlibp/server/TWM client/TWM Client Cmd Get Versions.vi"/>
				<Item Name="TWM Client Measure and Get Result.vi" Type="VI" URL="../external libraries/TWM client.lvlibp/server/TWM client/TWM Client Measure and Get Result.vi"/>
				<Item Name="TWM Client Recieve Packet.vi" Type="VI" URL="../external libraries/TWM client.lvlibp/server/TWM client/TWM Client Recieve Packet.vi"/>
				<Item Name="TWM Client Send Packet.vi" Type="VI" URL="../external libraries/TWM client.lvlibp/server/TWM client/TWM Client Send Packet.vi"/>
				<Item Name="TWM Client Wait ACK.vi" Type="VI" URL="../external libraries/TWM client.lvlibp/server/TWM client/TWM Client Wait ACK.vi"/>
				<Item Name="TWM Client Test.vi" Type="VI" URL="../external libraries/TWM client.lvlibp/server/TWM client/TWM Client Test.vi"/>
				<Item Name="TWM Client Open.vi" Type="VI" URL="../external libraries/TWM client.lvlibp/server/TWM client/TWM Client Open.vi"/>
				<Item Name="TWM Client Close.vi" Type="VI" URL="../external libraries/TWM client.lvlibp/server/TWM client/TWM Client Close.vi"/>
				<Item Name="TWM Client Version.vi" Type="VI" URL="../external libraries/TWM client.lvlibp/server/TWM client/TWM Client Version.vi"/>
				<Item Name="TWM Client Compare Version Strings.vi" Type="VI" URL="../external libraries/TWM client.lvlibp/server/TWM client/TWM Client Compare Version Strings.vi"/>
				<Item Name="TWM Client Cmd Define Multiplexer Paths.vi" Type="VI" URL="../external libraries/TWM client.lvlibp/server/TWM client/TWM Client Cmd Define Multiplexer Paths.vi"/>
				<Item Name="TWM Client Cmd Define Multiplexer Sequence.vi" Type="VI" URL="../external libraries/TWM client.lvlibp/server/TWM client/TWM Client Cmd Define Multiplexer Sequence.vi"/>
				<Item Name="TWM Client Cmd Define QPMX.vi" Type="VI" URL="../external libraries/TWM client.lvlibp/server/TWM client/TWM Client Cmd Define QPMX.vi"/>
				<Item Name="infolib.lvlib" Type="Library" URL="../external libraries/TWM client.lvlibp/octave/infolib/infolib.lvlib"/>
				<Item Name="Trim Whitespace.vi" Type="VI" URL="../external libraries/TWM client.lvlibp/1abvi3w/vi.lib/Utility/error.llb/Trim Whitespace.vi"/>
				<Item Name="whitespace.ctl" Type="VI" URL="../external libraries/TWM client.lvlibp/1abvi3w/vi.lib/Utility/error.llb/whitespace.ctl"/>
				<Item Name="Clear Errors.vi" Type="VI" URL="../external libraries/TWM client.lvlibp/1abvi3w/vi.lib/Utility/error.llb/Clear Errors.vi"/>
				<Item Name="Error Cluster From Error Code.vi" Type="VI" URL="../external libraries/TWM client.lvlibp/1abvi3w/vi.lib/Utility/error.llb/Error Cluster From Error Code.vi"/>
				<Item Name="Normalize End Of Line.vi" Type="VI" URL="../external libraries/TWM client.lvlibp/1abvi3w/vi.lib/AdvancedString/Normalize End Of Line.vi"/>
				<Item Name="wa32 ReadFile.vi" Type="VI" URL="../external libraries/TWM client.lvlibp/server/WinAPI32/wa32 ReadFile.vi"/>
				<Item Name="wa32 PeekNamedPipe.vi" Type="VI" URL="../external libraries/TWM client.lvlibp/server/WinAPI32/wa32 PeekNamedPipe.vi"/>
				<Item Name="wa32 Read Till Key.vi" Type="VI" URL="../external libraries/TWM client.lvlibp/server/WinAPI32/high level/wa32 Read Till Key.vi"/>
				<Item Name="wa32 WriteFile.vi" Type="VI" URL="../external libraries/TWM client.lvlibp/server/WinAPI32/wa32 WriteFile.vi"/>
				<Item Name="Space Constant.vi" Type="VI" URL="../external libraries/TWM client.lvlibp/1abvi3w/vi.lib/dlg_ctls.llb/Space Constant.vi"/>
				<Item Name="wa32 Flush Read.vi" Type="VI" URL="../external libraries/TWM client.lvlibp/server/WinAPI32/high level/wa32 Flush Read.vi"/>
				<Item Name="wa32 CloseHandle.vi" Type="VI" URL="../external libraries/TWM client.lvlibp/server/WinAPI32/wa32 CloseHandle.vi"/>
				<Item Name="wa32 CreateFileA.vi" Type="VI" URL="../external libraries/TWM client.lvlibp/server/WinAPI32/wa32 CreateFileA.vi"/>
				<Item Name="wa32 WaitNamedPipeA.vi" Type="VI" URL="../external libraries/TWM client.lvlibp/server/WinAPI32/wa32 WaitNamedPipeA.vi"/>
			</Item>
			<Item Name="varilib.lvlib" Type="Library" URL="../external libraries/varilib/varilib.lvlib"/>
		</Item>
		<Item Name="General AWG" Type="Folder">
			<Item Name="Type definitions" Type="Folder">
				<Item Name="AWG type.ctl" Type="VI" URL="../General AWG/Type definitions/AWG type.ctl"/>
				<Item Name="AWG.ctl" Type="VI" URL="../General AWG/Type definitions/AWG.ctl"/>
			</Item>
			<Item Name="AWG Type to AWG lib type.vi" Type="VI" URL="../General AWG/AWG Type to AWG lib type.vi"/>
			<Item Name="Init AWG.vi" Type="VI" URL="../General AWG/Init AWG.vi"/>
			<Item Name="Start AWG.vi" Type="VI" URL="../General AWG/Start AWG.vi"/>
			<Item Name="Stop AWG.vi" Type="VI" URL="../General AWG/Stop AWG.vi"/>
		</Item>
		<Item Name="General PJVS driver" Type="Folder">
			<Item Name="Type definitions" Type="Folder">
				<Item Name="PJVS Setup.ctl" Type="VI" URL="../General PJVS driver/Type definitions/PJVS Setup.ctl"/>
				<Item Name="PJVS Type.ctl" Type="VI" URL="../General PJVS driver/Type definitions/PJVS Type.ctl"/>
			</Item>
			<Item Name="Close PJVS.vi" Type="VI" URL="../General PJVS driver/Close PJVS.vi"/>
			<Item Name="Initialize PJVS.vi" Type="VI" URL="../General PJVS driver/Initialize PJVS.vi"/>
			<Item Name="Start PJVS.vi" Type="VI" URL="../General PJVS driver/Start PJVS.vi"/>
			<Item Name="Stop PJVS.vi" Type="VI" URL="../General PJVS driver/Stop PJVS.vi"/>
			<Item Name="Test PJVS.vi" Type="VI" URL="../General PJVS driver/Test PJVS.vi"/>
		</Item>
		<Item Name="GUI" Type="Folder">
			<Item Name="About Dialog.vi" Type="VI" URL="../GUI/About Dialog.vi"/>
			<Item Name="GUI AWG setup.vi" Type="VI" URL="../GUI/GUI AWG setup.vi"/>
			<Item Name="GUI Connections.vi" Type="VI" URL="../GUI/GUI Connections.vi"/>
			<Item Name="GUI main.vi" Type="VI" URL="../GUI/GUI main.vi"/>
			<Item Name="GUI Measurement setup.vi" Type="VI" URL="../GUI/GUI Measurement setup.vi"/>
			<Item Name="GUI PJVS setup.vi" Type="VI" URL="../GUI/GUI PJVS setup.vi"/>
			<Item Name="GUI TWM setup.vi" Type="VI" URL="../GUI/GUI TWM setup.vi"/>
			<Item Name="GUI Waveform.vi" Type="VI" URL="../GUI/GUI Waveform.vi"/>
		</Item>
		<Item Name="Measurement" Type="Folder">
			<Item Name="Type definitions" Type="Folder">
				<Item Name="Measuement properties.ctl" Type="VI" URL="../Measurement/Type definitions/Measuement properties.ctl"/>
				<Item Name="Measurement ID.ctl" Type="VI" URL="../Measurement/Type definitions/Measurement ID.ctl"/>
				<Item Name="QPSsettings.ctl" Type="VI" URL="../General PJVS driver/QPSsettings.ctl"/>
				<Item Name="Trigger mode.ctl" Type="VI" URL="../Measurement/Type definitions/Trigger mode.ctl"/>
			</Item>
			<Item Name="Calc Measruement Details.vi" Type="VI" URL="../Measurement/Calc Measruement Details.vi"/>
			<Item Name="Get Measruement Scenario.vi" Type="VI" URL="../Measurement/Get Measruement Scenario.vi"/>
			<Item Name="Measure.vi" Type="VI" URL="../Measurement/Measure.vi"/>
			<Item Name="Set TWM Corrections.vi" Type="VI" URL="../Measurement/Set TWM Corrections.vi"/>
			<Item Name="Set TWM Measurement.vi" Type="VI" URL="../Measurement/Set TWM Measurement.vi"/>
			<Item Name="Set TWM Processing.vi" Type="VI" URL="../Measurement/Set TWM Processing.vi"/>
			<Item Name="TWM Wait for Measure End.vi" Type="VI" URL="../Measurement/TWM Wait for Measure End.vi"/>
		</Item>
		<Item Name="PJVS drivers" Type="Folder">
			<Item Name="JV modified NPL Bias source" Type="Folder" URL="../PJVS drivers/JV modified NPL Bias source">
				<Property Name="NI.DISK" Type="Bool">true</Property>
			</Item>
			<Item Name="ACSVcontrol-driver.lvlib" Type="Library" URL="../PJVS drivers/acsvcontrol-driver/build/ACSVcontrol-driver_0.2.1.0.llb/ACSVcontrol-driver.lvlib"/>
		</Item>
		<Item Name="Utilities" Type="Folder">
			<Item Name="GCD of array.vi" Type="VI" URL="../Utilities/GCD of array.vi"/>
			<Item Name="Generate Dummy Channel Correction Text.vi" Type="VI" URL="../Utilities/Generate Dummy Channel Correction Text.vi"/>
			<Item Name="Generate Dummy Digitizer Corrections Files.vi" Type="VI" URL="../Utilities/Generate Dummy Digitizer Corrections Files.vi"/>
			<Item Name="Generate Dummy Digitizer Main Correction Text.vi" Type="VI" URL="../Utilities/Generate Dummy Digitizer Main Correction Text.vi"/>
			<Item Name="Get number of channels from digitizer correction file.vi" Type="VI" URL="../Utilities/Get number of channels from digitizer correction file.vi"/>
			<Item Name="Make Default QPS.vi" Type="VI" URL="../Utilities/Make Default QPS.vi"/>
			<Item Name="Merge Error Ex.vi" Type="VI" URL="../Utilities/Merge Error Ex.vi"/>
			<Item Name="Read settings from file.vi" Type="VI" URL="../Utilities/Read settings from file.vi"/>
			<Item Name="Save settings to file.vi" Type="VI" URL="../Utilities/Save settings to file.vi"/>
		</Item>
		<Item Name="Dependencies" Type="Dependencies">
			<Item Name="instr.lib" Type="Folder">
				<Item Name="niFgen Abort Generation.vi" Type="VI" URL="/&lt;instrlib&gt;/niFgen/niFgen.llb/niFgen Abort Generation.vi"/>
				<Item Name="niFgen Close.vi" Type="VI" URL="/&lt;instrlib&gt;/niFgen/niFgen.llb/niFgen Close.vi"/>
				<Item Name="niFgen Configure Output Mode.vi" Type="VI" URL="/&lt;instrlib&gt;/niFgen/niFgen.llb/niFgen Configure Output Mode.vi"/>
				<Item Name="niFgen Configure Sample Clock Source.vi" Type="VI" URL="/&lt;instrlib&gt;/niFgen/niFgen.llb/niFgen Configure Sample Clock Source.vi"/>
				<Item Name="niFgen Configure Standard Waveform.vi" Type="VI" URL="/&lt;instrlib&gt;/niFgen/niFgen.llb/niFgen Configure Standard Waveform.vi"/>
				<Item Name="niFgen Get Session Reference.vi" Type="VI" URL="/&lt;instrlib&gt;/niFgen/niFgen.llb/niFgen Get Session Reference.vi"/>
				<Item Name="niFgen Initialize With Channels.vi" Type="VI" URL="/&lt;instrlib&gt;/niFgen/niFgen.llb/niFgen Initialize With Channels.vi"/>
				<Item Name="niFgen Initiate Generation.vi" Type="VI" URL="/&lt;instrlib&gt;/niFgen/niFgen.llb/niFgen Initiate Generation.vi"/>
				<Item Name="niFgen IVI Error Converter.vi" Type="VI" URL="/&lt;instrlib&gt;/niFgen/niFgen.llb/niFgen IVI Error Converter.vi"/>
				<Item Name="niFgen Output Mode.ctl" Type="VI" URL="/&lt;instrlib&gt;/niFgen/niFgen.llb/niFgen Output Mode.ctl"/>
				<Item Name="niFgen Waveform Type.ctl" Type="VI" URL="/&lt;instrlib&gt;/niFgen/niFgen.llb/niFgen Waveform Type.ctl"/>
				<Item Name="niFgen_ctl Sample Clock Source Values (Ring).ctl" Type="VI" URL="/&lt;instrlib&gt;/niFgen/niFgen.llb/niFgen_ctl Sample Clock Source Values (Ring).ctl"/>
				<Item Name="niScope Acquisition Status.vi" Type="VI" URL="/&lt;instrlib&gt;/niScope/Acquire/Fetch/niScope Acquisition Status.vi"/>
				<Item Name="niScope Actual Record Length.vi" Type="VI" URL="/&lt;instrlib&gt;/niScope/Configure/Horizontal/niScope Actual Record Length.vi"/>
				<Item Name="niScope Close.vi" Type="VI" URL="/&lt;instrlib&gt;/niScope/niScope Close.vi"/>
				<Item Name="niScope Commit.vi" Type="VI" URL="/&lt;instrlib&gt;/niScope/Utility/niScope Commit.vi"/>
				<Item Name="niScope Configure Horizontal Timing.vi" Type="VI" URL="/&lt;instrlib&gt;/niScope/Configure/Horizontal/niScope Configure Horizontal Timing.vi"/>
				<Item Name="niScope Configure Trigger (poly).vi" Type="VI" URL="/&lt;instrlib&gt;/niScope/Configure/Trigger/niScope Configure Trigger (poly).vi"/>
				<Item Name="niScope Configure Trigger Digital.vi" Type="VI" URL="/&lt;instrlib&gt;/niScope/Configure/Trigger/niScope Configure Trigger Digital.vi"/>
				<Item Name="niScope Configure Trigger Edge.vi" Type="VI" URL="/&lt;instrlib&gt;/niScope/Configure/Trigger/niScope Configure Trigger Edge.vi"/>
				<Item Name="niScope Configure Trigger Glitch.vi" Type="VI" URL="/&lt;instrlib&gt;/niScope/Configure/Trigger/niScope Configure Trigger Glitch.vi"/>
				<Item Name="niScope Configure Trigger Hysteresis.vi" Type="VI" URL="/&lt;instrlib&gt;/niScope/Configure/Trigger/niScope Configure Trigger Hysteresis.vi"/>
				<Item Name="niScope Configure Trigger Immediate.vi" Type="VI" URL="/&lt;instrlib&gt;/niScope/Configure/Trigger/niScope Configure Trigger Immediate.vi"/>
				<Item Name="niScope Configure Trigger Runt.vi" Type="VI" URL="/&lt;instrlib&gt;/niScope/Configure/Trigger/niScope Configure Trigger Runt.vi"/>
				<Item Name="niScope Configure Trigger Software.vi" Type="VI" URL="/&lt;instrlib&gt;/niScope/Configure/Trigger/niScope Configure Trigger Software.vi"/>
				<Item Name="niScope Configure Trigger Width.vi" Type="VI" URL="/&lt;instrlib&gt;/niScope/Configure/Trigger/niScope Configure Trigger Width.vi"/>
				<Item Name="niScope Configure Trigger Window.vi" Type="VI" URL="/&lt;instrlib&gt;/niScope/Configure/Trigger/niScope Configure Trigger Window.vi"/>
				<Item Name="niScope Configure Vertical.vi" Type="VI" URL="/&lt;instrlib&gt;/niScope/Configure/Vertical/niScope Configure Vertical.vi"/>
				<Item Name="niScope Configure Video Trigger.vi" Type="VI" URL="/&lt;instrlib&gt;/niScope/Configure/Trigger/niScope Configure Video Trigger.vi"/>
				<Item Name="niScope export destinations.ctl" Type="VI" URL="/&lt;instrlib&gt;/niScope/Controls/niScope export destinations.ctl"/>
				<Item Name="niScope Export Signal.vi" Type="VI" URL="/&lt;instrlib&gt;/niScope/Configure/Trigger/niScope Export Signal.vi"/>
				<Item Name="niScope exportable signals.ctl" Type="VI" URL="/&lt;instrlib&gt;/niScope/Controls/niScope exportable signals.ctl"/>
				<Item Name="niScope Fetch (poly).vi" Type="VI" URL="/&lt;instrlib&gt;/niScope/Acquire/Fetch/niScope Fetch (poly).vi"/>
				<Item Name="niScope Fetch Binary 8.vi" Type="VI" URL="/&lt;instrlib&gt;/niScope/Acquire/Fetch/niScope Fetch Binary 8.vi"/>
				<Item Name="niScope Fetch Binary 16.vi" Type="VI" URL="/&lt;instrlib&gt;/niScope/Acquire/Fetch/niScope Fetch Binary 16.vi"/>
				<Item Name="niScope Fetch Binary 32.vi" Type="VI" URL="/&lt;instrlib&gt;/niScope/Acquire/Fetch/niScope Fetch Binary 32.vi"/>
				<Item Name="niScope Fetch Cluster Complex Double.vi" Type="VI" URL="/&lt;instrlib&gt;/niScope/Acquire/Fetch/niScope Fetch Cluster Complex Double.vi"/>
				<Item Name="niScope Fetch Cluster.vi" Type="VI" URL="/&lt;instrlib&gt;/niScope/Acquire/Fetch/niScope Fetch Cluster.vi"/>
				<Item Name="niScope Fetch Complex Double.vi" Type="VI" URL="/&lt;instrlib&gt;/niScope/Acquire/Fetch/niScope Fetch Complex Double.vi"/>
				<Item Name="niScope Fetch Complex WDT.vi" Type="VI" URL="/&lt;instrlib&gt;/niScope/Acquire/Fetch/niScope Fetch Complex WDT.vi"/>
				<Item Name="niScope Fetch Error Chain.vi" Type="VI" URL="/&lt;instrlib&gt;/niScope/Acquire/Fetch/niScope Fetch Error Chain.vi"/>
				<Item Name="niScope Fetch WDT.vi" Type="VI" URL="/&lt;instrlib&gt;/niScope/Acquire/Fetch/niScope Fetch WDT.vi"/>
				<Item Name="niScope Fetch.vi" Type="VI" URL="/&lt;instrlib&gt;/niScope/Acquire/Fetch/niScope Fetch.vi"/>
				<Item Name="niScope Get Session Reference.vi" Type="VI" URL="/&lt;instrlib&gt;/niScope/Utility/niScope Get Session Reference.vi"/>
				<Item Name="niScope glitch condition.ctl" Type="VI" URL="/&lt;instrlib&gt;/niScope/Controls/niScope glitch condition.ctl"/>
				<Item Name="niScope Initialize.vi" Type="VI" URL="/&lt;instrlib&gt;/niScope/niScope Initialize.vi"/>
				<Item Name="niScope Initiate Acquisition.vi" Type="VI" URL="/&lt;instrlib&gt;/niScope/Acquire/Fetch/niScope Initiate Acquisition.vi"/>
				<Item Name="niScope LabVIEW Error.vi" Type="VI" URL="/&lt;instrlib&gt;/niScope/Utility/niScope LabVIEW Error.vi"/>
				<Item Name="niScope Multi Fetch Binary 8.vi" Type="VI" URL="/&lt;instrlib&gt;/niScope/Acquire/Fetch/niScope Multi Fetch Binary 8.vi"/>
				<Item Name="niScope Multi Fetch Binary 16.vi" Type="VI" URL="/&lt;instrlib&gt;/niScope/Acquire/Fetch/niScope Multi Fetch Binary 16.vi"/>
				<Item Name="niScope Multi Fetch Binary 32.vi" Type="VI" URL="/&lt;instrlib&gt;/niScope/Acquire/Fetch/niScope Multi Fetch Binary 32.vi"/>
				<Item Name="niScope Multi Fetch Cluster Complex Double.vi" Type="VI" URL="/&lt;instrlib&gt;/niScope/Acquire/Fetch/niScope Multi Fetch Cluster Complex Double.vi"/>
				<Item Name="niScope Multi Fetch Cluster.vi" Type="VI" URL="/&lt;instrlib&gt;/niScope/Acquire/Fetch/niScope Multi Fetch Cluster.vi"/>
				<Item Name="niScope Multi Fetch Complex Double.vi" Type="VI" URL="/&lt;instrlib&gt;/niScope/Acquire/Fetch/niScope Multi Fetch Complex Double.vi"/>
				<Item Name="niScope Multi Fetch Complex WDT.vi" Type="VI" URL="/&lt;instrlib&gt;/niScope/Acquire/Fetch/niScope Multi Fetch Complex WDT.vi"/>
				<Item Name="niScope Multi Fetch WDT.vi" Type="VI" URL="/&lt;instrlib&gt;/niScope/Acquire/Fetch/niScope Multi Fetch WDT.vi"/>
				<Item Name="niScope Multi Fetch.vi" Type="VI" URL="/&lt;instrlib&gt;/niScope/Acquire/Fetch/niScope Multi Fetch.vi"/>
				<Item Name="niScope polarity.ctl" Type="VI" URL="/&lt;instrlib&gt;/niScope/Controls/niScope polarity.ctl"/>
				<Item Name="niScope signal format.ctl" Type="VI" URL="/&lt;instrlib&gt;/niScope/Controls/niScope signal format.ctl"/>
				<Item Name="niScope timestamp type.ctl" Type="VI" URL="/&lt;instrlib&gt;/niScope/Controls/niScope timestamp type.ctl"/>
				<Item Name="niScope trigger coupling.ctl" Type="VI" URL="/&lt;instrlib&gt;/niScope/Controls/niScope trigger coupling.ctl"/>
				<Item Name="niScope trigger polarity.ctl" Type="VI" URL="/&lt;instrlib&gt;/niScope/Controls/niScope trigger polarity.ctl"/>
				<Item Name="niScope trigger slope.ctl" Type="VI" URL="/&lt;instrlib&gt;/niScope/Controls/niScope trigger slope.ctl"/>
				<Item Name="niScope trigger source digital.ctl" Type="VI" URL="/&lt;instrlib&gt;/niScope/Controls/niScope trigger source digital.ctl"/>
				<Item Name="niScope trigger source.ctl" Type="VI" URL="/&lt;instrlib&gt;/niScope/Controls/niScope trigger source.ctl"/>
				<Item Name="niScope trigger window mode.ctl" Type="VI" URL="/&lt;instrlib&gt;/niScope/Controls/niScope trigger window mode.ctl"/>
				<Item Name="niScope tv event.ctl" Type="VI" URL="/&lt;instrlib&gt;/niScope/Controls/niScope tv event.ctl"/>
				<Item Name="niScope vertical coupling.ctl" Type="VI" URL="/&lt;instrlib&gt;/niScope/Controls/niScope vertical coupling.ctl"/>
				<Item Name="niScope which signal.ctl" Type="VI" URL="/&lt;instrlib&gt;/niScope/Controls/niScope which signal.ctl"/>
			</Item>
			<Item Name="vi.lib" Type="Folder">
				<Item Name="Application Directory.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Application Directory.vi"/>
				<Item Name="Bit-array To Byte-array.vi" Type="VI" URL="/&lt;vilib&gt;/picture/pictutil.llb/Bit-array To Byte-array.vi"/>
				<Item Name="BuildErrorSource.vi" Type="VI" URL="/&lt;vilib&gt;/Platform/fileVersionInfo.llb/BuildErrorSource.vi"/>
				<Item Name="BuildHelpPath.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/BuildHelpPath.vi"/>
				<Item Name="Built App File Layout.vi" Type="VI" URL="/&lt;vilib&gt;/AppBuilder/Built App File Layout.vi"/>
				<Item Name="Calc Long Word Padded Width.vi" Type="VI" URL="/&lt;vilib&gt;/picture/bmp.llb/Calc Long Word Padded Width.vi"/>
				<Item Name="Check Color Table Size.vi" Type="VI" URL="/&lt;vilib&gt;/picture/jpeg.llb/Check Color Table Size.vi"/>
				<Item Name="Check Data Size.vi" Type="VI" URL="/&lt;vilib&gt;/picture/jpeg.llb/Check Data Size.vi"/>
				<Item Name="Check File Permissions.vi" Type="VI" URL="/&lt;vilib&gt;/picture/jpeg.llb/Check File Permissions.vi"/>
				<Item Name="Check if File or Folder Exists.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/libraryn.llb/Check if File or Folder Exists.vi"/>
				<Item Name="Check Path.vi" Type="VI" URL="/&lt;vilib&gt;/picture/jpeg.llb/Check Path.vi"/>
				<Item Name="Check Special Tags.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Check Special Tags.vi"/>
				<Item Name="Clear Errors.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Clear Errors.vi"/>
				<Item Name="Close File+.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Close File+.vi"/>
				<Item Name="Close Registry Key.vi" Type="VI" URL="/&lt;vilib&gt;/registry/registry.llb/Close Registry Key.vi"/>
				<Item Name="compatCalcOffset.vi" Type="VI" URL="/&lt;vilib&gt;/_oldvers/_oldvers.llb/compatCalcOffset.vi"/>
				<Item Name="compatFileDialog.vi" Type="VI" URL="/&lt;vilib&gt;/_oldvers/_oldvers.llb/compatFileDialog.vi"/>
				<Item Name="compatOpenFileOperation.vi" Type="VI" URL="/&lt;vilib&gt;/_oldvers/_oldvers.llb/compatOpenFileOperation.vi"/>
				<Item Name="compatReadText.vi" Type="VI" URL="/&lt;vilib&gt;/_oldvers/_oldvers.llb/compatReadText.vi"/>
				<Item Name="Convert property node font to graphics font.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Convert property node font to graphics font.vi"/>
				<Item Name="Create ActiveX Event Queue.vi" Type="VI" URL="/&lt;vilib&gt;/Platform/ax-events.llb/Create ActiveX Event Queue.vi"/>
				<Item Name="Create Directory Recursive.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/libraryn.llb/Create Directory Recursive.vi"/>
				<Item Name="Create Error Clust.vi" Type="VI" URL="/&lt;vilib&gt;/Platform/ax-events.llb/Create Error Clust.vi"/>
				<Item Name="Create Mask By Alpha.vi" Type="VI" URL="/&lt;vilib&gt;/picture/picture.llb/Create Mask By Alpha.vi"/>
				<Item Name="Destroy ActiveX Event Queue.vi" Type="VI" URL="/&lt;vilib&gt;/Platform/ax-events.llb/Destroy ActiveX Event Queue.vi"/>
				<Item Name="Details Display Dialog.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Details Display Dialog.vi"/>
				<Item Name="DialogType.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/DialogType.ctl"/>
				<Item Name="DialogTypeEnum.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/DialogTypeEnum.ctl"/>
				<Item Name="Directory of Top Level VI.vi" Type="VI" URL="/&lt;vilib&gt;/picture/jpeg.llb/Directory of Top Level VI.vi"/>
				<Item Name="Draw Flattened Pixmap.vi" Type="VI" URL="/&lt;vilib&gt;/picture/picture.llb/Draw Flattened Pixmap.vi"/>
				<Item Name="DTbl Digital Size.vi" Type="VI" URL="/&lt;vilib&gt;/Waveform/DTblOps.llb/DTbl Digital Size.vi"/>
				<Item Name="DU64_U32AddWithOverflow.vi" Type="VI" URL="/&lt;vilib&gt;/Waveform/TSOps.llb/DU64_U32AddWithOverflow.vi"/>
				<Item Name="DU64_U32SubtractWithBorrow.vi" Type="VI" URL="/&lt;vilib&gt;/Waveform/TSOps.llb/DU64_U32SubtractWithBorrow.vi"/>
				<Item Name="DWDT Digital Size.vi" Type="VI" URL="/&lt;vilib&gt;/Waveform/DWDTOps.llb/DWDT Digital Size.vi"/>
				<Item Name="DWDT Get Waveform Time Array.vi" Type="VI" URL="/&lt;vilib&gt;/Waveform/DWDTOps.llb/DWDT Get Waveform Time Array.vi"/>
				<Item Name="Dynamic To Waveform Array.vi" Type="VI" URL="/&lt;vilib&gt;/express/express shared/transition.llb/Dynamic To Waveform Array.vi"/>
				<Item Name="Equal Comparable.lvclass" Type="LVClass" URL="/&lt;vilib&gt;/Comparison/Equal/Equal Comparable/Equal Comparable.lvclass"/>
				<Item Name="Equal Functor.lvclass" Type="LVClass" URL="/&lt;vilib&gt;/Comparison/Equal/Equal Functor/Equal Functor.lvclass"/>
				<Item Name="Equals.vim" Type="VI" URL="/&lt;vilib&gt;/Comparison/Equals.vim"/>
				<Item Name="Error Cluster From Error Code.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Error Cluster From Error Code.vi"/>
				<Item Name="Error Code Database.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Error Code Database.vi"/>
				<Item Name="ErrWarn.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/ErrWarn.ctl"/>
				<Item Name="Escape Characters for HTTP.vi" Type="VI" URL="/&lt;vilib&gt;/printing/PathToURL.llb/Escape Characters for HTTP.vi"/>
				<Item Name="EventData.ctl" Type="VI" URL="/&lt;vilib&gt;/Platform/ax-events.llb/EventData.ctl"/>
				<Item Name="eventvkey.ctl" Type="VI" URL="/&lt;vilib&gt;/event_ctls.llb/eventvkey.ctl"/>
				<Item Name="ex_CorrectErrorChain.vi" Type="VI" URL="/&lt;vilib&gt;/express/express shared/ex_CorrectErrorChain.vi"/>
				<Item Name="ex_GenAddAttribs.vi" Type="VI" URL="/&lt;vilib&gt;/express/express input/SimulateSignalBlock.llb/ex_GenAddAttribs.vi"/>
				<Item Name="ex_SetAllExpressAttribs.vi" Type="VI" URL="/&lt;vilib&gt;/express/express shared/transition.llb/ex_SetAllExpressAttribs.vi"/>
				<Item Name="ex_SetExpAttribsAndT0.vi" Type="VI" URL="/&lt;vilib&gt;/express/express shared/transition.llb/ex_SetExpAttribsAndT0.vi"/>
				<Item Name="ex_WaveformAttribs.ctl" Type="VI" URL="/&lt;vilib&gt;/express/express shared/transition.llb/ex_WaveformAttribs.ctl"/>
				<Item Name="ex_WaveformAttribsPlus.ctl" Type="VI" URL="/&lt;vilib&gt;/express/express shared/transition.llb/ex_WaveformAttribsPlus.ctl"/>
				<Item Name="FileVersionInfo.vi" Type="VI" URL="/&lt;vilib&gt;/Platform/fileVersionInfo.llb/FileVersionInfo.vi"/>
				<Item Name="FileVersionInformation.ctl" Type="VI" URL="/&lt;vilib&gt;/Platform/fileVersionInfo.llb/FileVersionInformation.ctl"/>
				<Item Name="Find First Error.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Find First Error.vi"/>
				<Item Name="Find Tag.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Find Tag.vi"/>
				<Item Name="FindCloseTagByName.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/xml.llb/FindCloseTagByName.vi"/>
				<Item Name="FindElement.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/xml.llb/FindElement.vi"/>
				<Item Name="FindElementStartByName.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/xml.llb/FindElementStartByName.vi"/>
				<Item Name="FindEmptyElement.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/xml.llb/FindEmptyElement.vi"/>
				<Item Name="FindFirstTag.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/xml.llb/FindFirstTag.vi"/>
				<Item Name="FindMatchingCloseTag.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/xml.llb/FindMatchingCloseTag.vi"/>
				<Item Name="FixBadRect.vi" Type="VI" URL="/&lt;vilib&gt;/picture/pictutil.llb/FixBadRect.vi"/>
				<Item Name="FixedFileInfo_Struct.ctl" Type="VI" URL="/&lt;vilib&gt;/Platform/fileVersionInfo.llb/FixedFileInfo_Struct.ctl"/>
				<Item Name="Flip and Pad for Picture Control.vi" Type="VI" URL="/&lt;vilib&gt;/picture/bmp.llb/Flip and Pad for Picture Control.vi"/>
				<Item Name="Format Message String.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Format Message String.vi"/>
				<Item Name="General Error Handler Core CORE.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/General Error Handler Core CORE.vi"/>
				<Item Name="General Error Handler.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/General Error Handler.vi"/>
				<Item Name="Generate Temporary File Path.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/libraryn.llb/Generate Temporary File Path.vi"/>
				<Item Name="Get File Extension.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/libraryn.llb/Get File Extension.vi"/>
				<Item Name="Get LV Class Default Value.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/LVClass/Get LV Class Default Value.vi"/>
				<Item Name="Get String Text Bounds.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Get String Text Bounds.vi"/>
				<Item Name="Get Text Rect.vi" Type="VI" URL="/&lt;vilib&gt;/picture/picture.llb/Get Text Rect.vi"/>
				<Item Name="Get Waveform Time Array.vi" Type="VI" URL="/&lt;vilib&gt;/Waveform/WDTOps.llb/Get Waveform Time Array.vi"/>
				<Item Name="GetFileVersionInfo.vi" Type="VI" URL="/&lt;vilib&gt;/Platform/fileVersionInfo.llb/GetFileVersionInfo.vi"/>
				<Item Name="GetFileVersionInfoSize.vi" Type="VI" URL="/&lt;vilib&gt;/Platform/fileVersionInfo.llb/GetFileVersionInfoSize.vi"/>
				<Item Name="GetHelpDir.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/GetHelpDir.vi"/>
				<Item Name="GetRTHostConnectedProp.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/GetRTHostConnectedProp.vi"/>
				<Item Name="Handle Open Word or Excel File.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/NIReport.llb/Toolkit/Handle Open Word or Excel File.vi"/>
				<Item Name="I128 Timestamp.ctl" Type="VI" URL="/&lt;vilib&gt;/Waveform/TSOps.llb/I128 Timestamp.ctl"/>
				<Item Name="imagedata.ctl" Type="VI" URL="/&lt;vilib&gt;/picture/picture.llb/imagedata.ctl"/>
				<Item Name="Less Comparable.lvclass" Type="LVClass" URL="/&lt;vilib&gt;/Comparison/Less/Less Comparable/Less Comparable.lvclass"/>
				<Item Name="Less Functor.lvclass" Type="LVClass" URL="/&lt;vilib&gt;/Comparison/Less/Less Functor/Less Functor.lvclass"/>
				<Item Name="Less.vim" Type="VI" URL="/&lt;vilib&gt;/Comparison/Less.vim"/>
				<Item Name="Longest Line Length in Pixels.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Longest Line Length in Pixels.vi"/>
				<Item Name="LVBoundsTypeDef.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/miscctls.llb/LVBoundsTypeDef.ctl"/>
				<Item Name="LVDateTimeRec.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/miscctls.llb/LVDateTimeRec.ctl"/>
				<Item Name="LVRectTypeDef.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/miscctls.llb/LVRectTypeDef.ctl"/>
				<Item Name="LVRowAndColumnTypeDef.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/miscctls.llb/LVRowAndColumnTypeDef.ctl"/>
				<Item Name="LVRowAndColumnUnsignedTypeDef.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/miscctls.llb/LVRowAndColumnUnsignedTypeDef.ctl"/>
				<Item Name="LVSelectionTypeDef.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/miscctls.llb/LVSelectionTypeDef.ctl"/>
				<Item Name="MoveMemory.vi" Type="VI" URL="/&lt;vilib&gt;/Platform/fileVersionInfo.llb/MoveMemory.vi"/>
				<Item Name="Nearest Freq in Int Cycles.vi" Type="VI" URL="/&lt;vilib&gt;/express/express input/SimulateSignalConfig.llb/Nearest Freq in Int Cycles.vi"/>
				<Item Name="Nearest Frequency for Block.vi" Type="VI" URL="/&lt;vilib&gt;/express/express input/SimulateSignalConfig.llb/Nearest Frequency for Block.vi"/>
				<Item Name="NI_AALBase.lvlib" Type="Library" URL="/&lt;vilib&gt;/Analysis/NI_AALBase.lvlib"/>
				<Item Name="NI_Excel.lvclass" Type="LVClass" URL="/&lt;vilib&gt;/Utility/NIReport.llb/Excel/NI_Excel.lvclass"/>
				<Item Name="NI_FileType.lvlib" Type="Library" URL="/&lt;vilib&gt;/Utility/lvfile.llb/NI_FileType.lvlib"/>
				<Item Name="NI_HTML.lvclass" Type="LVClass" URL="/&lt;vilib&gt;/Utility/NIReport.llb/HTML/NI_HTML.lvclass"/>
				<Item Name="NI_MABase.lvlib" Type="Library" URL="/&lt;vilib&gt;/measure/NI_MABase.lvlib"/>
				<Item Name="NI_Matrix.lvlib" Type="Library" URL="/&lt;vilib&gt;/Analysis/Matrix/NI_Matrix.lvlib"/>
				<Item Name="NI_PackedLibraryUtility.lvlib" Type="Library" URL="/&lt;vilib&gt;/Utility/LVLibp/NI_PackedLibraryUtility.lvlib"/>
				<Item Name="NI_report.lvclass" Type="LVClass" URL="/&lt;vilib&gt;/Utility/NIReport.llb/NI_report.lvclass"/>
				<Item Name="NI_ReportGenerationCore.lvlib" Type="Library" URL="/&lt;vilib&gt;/Utility/NIReport.llb/NI_ReportGenerationCore.lvlib"/>
				<Item Name="NI_ReportGenerationToolkit.lvlib" Type="Library" URL="/&lt;vilib&gt;/addons/_office/NI_ReportGenerationToolkit.lvlib"/>
				<Item Name="NI_Standard Report.lvclass" Type="LVClass" URL="/&lt;vilib&gt;/Utility/NIReport.llb/Standard Report/NI_Standard Report.lvclass"/>
				<Item Name="Normalize End Of Line.vi" Type="VI" URL="/&lt;vilib&gt;/AdvancedString/Normalize End Of Line.vi"/>
				<Item Name="Not Found Dialog.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Not Found Dialog.vi"/>
				<Item Name="Number of Waveform Samples.vi" Type="VI" URL="/&lt;vilib&gt;/Waveform/WDTOps.llb/Number of Waveform Samples.vi"/>
				<Item Name="OccFireType.ctl" Type="VI" URL="/&lt;vilib&gt;/Platform/ax-events.llb/OccFireType.ctl"/>
				<Item Name="Open File+.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Open File+.vi"/>
				<Item Name="Open Registry Key.vi" Type="VI" URL="/&lt;vilib&gt;/registry/registry.llb/Open Registry Key.vi"/>
				<Item Name="Open URL in Default Browser (path).vi" Type="VI" URL="/&lt;vilib&gt;/Platform/browser.llb/Open URL in Default Browser (path).vi"/>
				<Item Name="Open URL in Default Browser (string).vi" Type="VI" URL="/&lt;vilib&gt;/Platform/browser.llb/Open URL in Default Browser (string).vi"/>
				<Item Name="Open URL in Default Browser core.vi" Type="VI" URL="/&lt;vilib&gt;/Platform/browser.llb/Open URL in Default Browser core.vi"/>
				<Item Name="Open URL in Default Browser.vi" Type="VI" URL="/&lt;vilib&gt;/Platform/browser.llb/Open URL in Default Browser.vi"/>
				<Item Name="Open_Create_Replace File.vi" Type="VI" URL="/&lt;vilib&gt;/_oldvers/_oldvers.llb/Open_Create_Replace File.vi"/>
				<Item Name="ParseXMLFragments.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/xml.llb/ParseXMLFragments.vi"/>
				<Item Name="Path to URL inner.vi" Type="VI" URL="/&lt;vilib&gt;/printing/PathToURL.llb/Path to URL inner.vi"/>
				<Item Name="Path to URL.vi" Type="VI" URL="/&lt;vilib&gt;/printing/PathToURL.llb/Path to URL.vi"/>
				<Item Name="Read Delimited Spreadsheet (DBL).vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Read Delimited Spreadsheet (DBL).vi"/>
				<Item Name="Read Delimited Spreadsheet (I64).vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Read Delimited Spreadsheet (I64).vi"/>
				<Item Name="Read Delimited Spreadsheet (string).vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Read Delimited Spreadsheet (string).vi"/>
				<Item Name="Read Delimited Spreadsheet.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Read Delimited Spreadsheet.vi"/>
				<Item Name="Read File+ (string).vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Read File+ (string).vi"/>
				<Item Name="Read From XML File(array).vi" Type="VI" URL="/&lt;vilib&gt;/Utility/xml.llb/Read From XML File(array).vi"/>
				<Item Name="Read From XML File(string).vi" Type="VI" URL="/&lt;vilib&gt;/Utility/xml.llb/Read From XML File(string).vi"/>
				<Item Name="Read From XML File.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/xml.llb/Read From XML File.vi"/>
				<Item Name="Read JPEG File.vi" Type="VI" URL="/&lt;vilib&gt;/picture/jpeg.llb/Read JPEG File.vi"/>
				<Item Name="Read Lines From File (with error IO).vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Read Lines From File (with error IO).vi"/>
				<Item Name="Read PNG File.vi" Type="VI" URL="/&lt;vilib&gt;/picture/png.llb/Read PNG File.vi"/>
				<Item Name="Read Registry Value DWORD.vi" Type="VI" URL="/&lt;vilib&gt;/registry/registry.llb/Read Registry Value DWORD.vi"/>
				<Item Name="Read Registry Value Simple STR.vi" Type="VI" URL="/&lt;vilib&gt;/registry/registry.llb/Read Registry Value Simple STR.vi"/>
				<Item Name="Read Registry Value Simple U32.vi" Type="VI" URL="/&lt;vilib&gt;/registry/registry.llb/Read Registry Value Simple U32.vi"/>
				<Item Name="Read Registry Value Simple.vi" Type="VI" URL="/&lt;vilib&gt;/registry/registry.llb/Read Registry Value Simple.vi"/>
				<Item Name="Read Registry Value STR.vi" Type="VI" URL="/&lt;vilib&gt;/registry/registry.llb/Read Registry Value STR.vi"/>
				<Item Name="Read Registry Value.vi" Type="VI" URL="/&lt;vilib&gt;/registry/registry.llb/Read Registry Value.vi"/>
				<Item Name="Registry Handle Master.vi" Type="VI" URL="/&lt;vilib&gt;/registry/registry.llb/Registry Handle Master.vi"/>
				<Item Name="Registry refnum.ctl" Type="VI" URL="/&lt;vilib&gt;/registry/registry.llb/Registry refnum.ctl"/>
				<Item Name="Registry RtKey.ctl" Type="VI" URL="/&lt;vilib&gt;/registry/registry.llb/Registry RtKey.ctl"/>
				<Item Name="Registry SAM.ctl" Type="VI" URL="/&lt;vilib&gt;/registry/registry.llb/Registry SAM.ctl"/>
				<Item Name="Registry Simplify Data Type.vi" Type="VI" URL="/&lt;vilib&gt;/registry/registry.llb/Registry Simplify Data Type.vi"/>
				<Item Name="Registry View.ctl" Type="VI" URL="/&lt;vilib&gt;/registry/registry.llb/Registry View.ctl"/>
				<Item Name="Registry WinErr-LVErr.vi" Type="VI" URL="/&lt;vilib&gt;/registry/registry.llb/Registry WinErr-LVErr.vi"/>
				<Item Name="Search and Replace Pattern.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Search and Replace Pattern.vi"/>
				<Item Name="Search Unsorted 1D Array Core.vim" Type="VI" URL="/&lt;vilib&gt;/Array/Helpers/Search Unsorted 1D Array Core.vim"/>
				<Item Name="Search Unsorted 1D Array.vim" Type="VI" URL="/&lt;vilib&gt;/Array/Search Unsorted 1D Array.vim"/>
				<Item Name="Select Event Type.ctl" Type="VI" URL="/&lt;vilib&gt;/Instr/_visa.llb/Select Event Type.ctl"/>
				<Item Name="Set Bold Text.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Set Bold Text.vi"/>
				<Item Name="Set Busy.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/cursorutil.llb/Set Busy.vi"/>
				<Item Name="Set Cursor (Cursor ID).vi" Type="VI" URL="/&lt;vilib&gt;/Utility/cursorutil.llb/Set Cursor (Cursor ID).vi"/>
				<Item Name="Set Cursor (Icon Pict).vi" Type="VI" URL="/&lt;vilib&gt;/Utility/cursorutil.llb/Set Cursor (Icon Pict).vi"/>
				<Item Name="Set Cursor.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/cursorutil.llb/Set Cursor.vi"/>
				<Item Name="Set String Value.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Set String Value.vi"/>
				<Item Name="Simple Error Handler.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Simple Error Handler.vi"/>
				<Item Name="Sort 1D Array Core.vim" Type="VI" URL="/&lt;vilib&gt;/Array/Helpers/Sort 1D Array Core.vim"/>
				<Item Name="Sort 1D Array.vim" Type="VI" URL="/&lt;vilib&gt;/Array/Sort 1D Array.vim"/>
				<Item Name="Space Constant.vi" Type="VI" URL="/&lt;vilib&gt;/dlg_ctls.llb/Space Constant.vi"/>
				<Item Name="Stall Data Flow.vim" Type="VI" URL="/&lt;vilib&gt;/Utility/Stall Data Flow.vim"/>
				<Item Name="STR_ASCII-Unicode.vi" Type="VI" URL="/&lt;vilib&gt;/registry/registry.llb/STR_ASCII-Unicode.vi"/>
				<Item Name="sub2ShouldUseDefSigName.vi" Type="VI" URL="/&lt;vilib&gt;/express/express input/SimulateSignalBlock.llb/sub2ShouldUseDefSigName.vi"/>
				<Item Name="subFile Dialog.vi" Type="VI" URL="/&lt;vilib&gt;/express/express input/FileDialogBlock.llb/subFile Dialog.vi"/>
				<Item Name="subGetSignalName.vi" Type="VI" URL="/&lt;vilib&gt;/express/express input/SimulateSignalBlock.llb/subGetSignalName.vi"/>
				<Item Name="subInternalTiming.vi" Type="VI" URL="/&lt;vilib&gt;/express/express input/SimulateSignalBlock.llb/subInternalTiming.vi"/>
				<Item Name="subShouldUseDefSigName.vi" Type="VI" URL="/&lt;vilib&gt;/express/express input/SimulateSignalBlock.llb/subShouldUseDefSigName.vi"/>
				<Item Name="subSigGeneratorBlock.vi" Type="VI" URL="/&lt;vilib&gt;/express/express input/SimulateSignalBlock.llb/subSigGeneratorBlock.vi"/>
				<Item Name="TagReturnType.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/TagReturnType.ctl"/>
				<Item Name="Three Button Dialog CORE.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Three Button Dialog CORE.vi"/>
				<Item Name="Three Button Dialog.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Three Button Dialog.vi"/>
				<Item Name="Timestamp Add.vi" Type="VI" URL="/&lt;vilib&gt;/Waveform/TSOps.llb/Timestamp Add.vi"/>
				<Item Name="Timestamp Subtract.vi" Type="VI" URL="/&lt;vilib&gt;/Waveform/TSOps.llb/Timestamp Subtract.vi"/>
				<Item Name="Trim Whitespace.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Trim Whitespace.vi"/>
				<Item Name="Unset Busy.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/cursorutil.llb/Unset Busy.vi"/>
				<Item Name="VerQueryValue.vi" Type="VI" URL="/&lt;vilib&gt;/Platform/fileVersionInfo.llb/VerQueryValue.vi"/>
				<Item Name="VISA Flush IO Buffer Mask.ctl" Type="VI" URL="/&lt;vilib&gt;/Instr/_visa.llb/VISA Flush IO Buffer Mask.ctl"/>
				<Item Name="VISA GPIB Control REN Mode.ctl" Type="VI" URL="/&lt;vilib&gt;/Instr/_visa.llb/VISA GPIB Control REN Mode.ctl"/>
				<Item Name="Wait On ActiveX Event.vi" Type="VI" URL="/&lt;vilib&gt;/Platform/ax-events.llb/Wait On ActiveX Event.vi"/>
				<Item Name="Wait types.ctl" Type="VI" URL="/&lt;vilib&gt;/Platform/ax-events.llb/Wait types.ctl"/>
				<Item Name="Waveform Array To Dynamic.vi" Type="VI" URL="/&lt;vilib&gt;/express/express shared/transition.llb/Waveform Array To Dynamic.vi"/>
				<Item Name="WDT Get Waveform Time Array DBL.vi" Type="VI" URL="/&lt;vilib&gt;/Waveform/WDTOps.llb/WDT Get Waveform Time Array DBL.vi"/>
				<Item Name="WDT Number of Waveform Samples CDB.vi" Type="VI" URL="/&lt;vilib&gt;/Waveform/WDTOps.llb/WDT Number of Waveform Samples CDB.vi"/>
				<Item Name="WDT Number of Waveform Samples DBL.vi" Type="VI" URL="/&lt;vilib&gt;/Waveform/WDTOps.llb/WDT Number of Waveform Samples DBL.vi"/>
				<Item Name="WDT Number of Waveform Samples EXT.vi" Type="VI" URL="/&lt;vilib&gt;/Waveform/WDTOps.llb/WDT Number of Waveform Samples EXT.vi"/>
				<Item Name="WDT Number of Waveform Samples I8.vi" Type="VI" URL="/&lt;vilib&gt;/Waveform/WDTOps.llb/WDT Number of Waveform Samples I8.vi"/>
				<Item Name="WDT Number of Waveform Samples I16.vi" Type="VI" URL="/&lt;vilib&gt;/Waveform/WDTOps.llb/WDT Number of Waveform Samples I16.vi"/>
				<Item Name="WDT Number of Waveform Samples I32.vi" Type="VI" URL="/&lt;vilib&gt;/Waveform/WDTOps.llb/WDT Number of Waveform Samples I32.vi"/>
				<Item Name="WDT Number of Waveform Samples SGL.vi" Type="VI" URL="/&lt;vilib&gt;/Waveform/WDTOps.llb/WDT Number of Waveform Samples SGL.vi"/>
				<Item Name="whitespace.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/whitespace.ctl"/>
				<Item Name="Write BMP Data To Buffer.vi" Type="VI" URL="/&lt;vilib&gt;/picture/bmp.llb/Write BMP Data To Buffer.vi"/>
				<Item Name="Write BMP Data.vi" Type="VI" URL="/&lt;vilib&gt;/picture/bmp.llb/Write BMP Data.vi"/>
				<Item Name="Write BMP File.vi" Type="VI" URL="/&lt;vilib&gt;/picture/bmp.llb/Write BMP File.vi"/>
				<Item Name="Write Delimited Spreadsheet (DBL).vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Write Delimited Spreadsheet (DBL).vi"/>
				<Item Name="Write Delimited Spreadsheet (I64).vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Write Delimited Spreadsheet (I64).vi"/>
				<Item Name="Write Delimited Spreadsheet (string).vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Write Delimited Spreadsheet (string).vi"/>
				<Item Name="Write Delimited Spreadsheet.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Write Delimited Spreadsheet.vi"/>
				<Item Name="Write JPEG File.vi" Type="VI" URL="/&lt;vilib&gt;/picture/jpeg.llb/Write JPEG File.vi"/>
				<Item Name="Write PNG File.vi" Type="VI" URL="/&lt;vilib&gt;/picture/png.llb/Write PNG File.vi"/>
				<Item Name="Write Spreadsheet String.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Write Spreadsheet String.vi"/>
				<Item Name="Write To Spreadsheet File (DBL).vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Write To Spreadsheet File (DBL).vi"/>
				<Item Name="Write To Spreadsheet File (I64).vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Write To Spreadsheet File (I64).vi"/>
				<Item Name="Write To Spreadsheet File (string).vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Write To Spreadsheet File (string).vi"/>
				<Item Name="Write To Spreadsheet File.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Write To Spreadsheet File.vi"/>
				<Item Name="Write to XML File(array).vi" Type="VI" URL="/&lt;vilib&gt;/Utility/xml.llb/Write to XML File(array).vi"/>
				<Item Name="Write to XML File(string).vi" Type="VI" URL="/&lt;vilib&gt;/Utility/xml.llb/Write to XML File(string).vi"/>
				<Item Name="Write to XML File.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/xml.llb/Write to XML File.vi"/>
			</Item>
			<Item Name="Advapi32.dll" Type="Document" URL="Advapi32.dll">
				<Property Name="NI.PreserveRelativePath" Type="Bool">true</Property>
			</Item>
			<Item Name="Basic NPL DS Write-Read.vi" Type="VI" URL="../PJVS drivers/Binary Array Server DAQmx 4 Apr 2016.llb/Basic NPL DS Write-Read.vi"/>
			<Item Name="DataSocketCluster.ctl" Type="VI" URL="../PJVS drivers/Binary Array Server DAQmx 4 Apr 2016.llb/DataSocketCluster.ctl"/>
			<Item Name="infolib.lvlib" Type="Library" URL="../../../TWM - github/lvprog/octave/infolib/infolib.lvlib"/>
			<Item Name="JOSY Binarray Datasocket cmd.vi" Type="VI" URL="../PJVS drivers/JOSY Binarray Datasocket cmd.vi"/>
			<Item Name="kernel32.dll" Type="Document" URL="kernel32.dll">
				<Property Name="NI.PreserveRelativePath" Type="Bool">true</Property>
			</Item>
			<Item Name="lvanlys.dll" Type="Document" URL="/&lt;resource&gt;/lvanlys.dll"/>
			<Item Name="niFgen_32.dll" Type="Document" URL="niFgen_32.dll">
				<Property Name="NI.PreserveRelativePath" Type="Bool">true</Property>
			</Item>
			<Item Name="niScope_32.dll" Type="Document" URL="niScope_32.dll">
				<Property Name="NI.PreserveRelativePath" Type="Bool">true</Property>
			</Item>
			<Item Name="TWM Client.lvlib" Type="Library" URL="../../../TWM - github/lvprog/server/TWM client/TWM Client.lvlib"/>
			<Item Name="version.dll" Type="Document" URL="version.dll">
				<Property Name="NI.PreserveRelativePath" Type="Bool">true</Property>
			</Item>
			<Item Name="vi Mode.ctl" Type="VI" URL="../PJVS drivers/Binary Array Server DAQmx 4 Apr 2016.llb/vi Mode.ctl"/>
			<Item Name="wa32 CloseHandle.vi" Type="VI" URL="../../../TWM - github/lvprog/server/WinAPI32/wa32 CloseHandle.vi"/>
			<Item Name="wa32 CreateFileA.vi" Type="VI" URL="../../../TWM - github/lvprog/server/WinAPI32/wa32 CreateFileA.vi"/>
			<Item Name="wa32 Flush Read.vi" Type="VI" URL="../../../TWM - github/lvprog/server/WinAPI32/high level/wa32 Flush Read.vi"/>
			<Item Name="wa32 PeekNamedPipe.vi" Type="VI" URL="../../../TWM - github/lvprog/server/WinAPI32/wa32 PeekNamedPipe.vi"/>
			<Item Name="wa32 Read Till Key.vi" Type="VI" URL="../../../TWM - github/lvprog/server/WinAPI32/high level/wa32 Read Till Key.vi"/>
			<Item Name="wa32 ReadFile.vi" Type="VI" URL="../../../TWM - github/lvprog/server/WinAPI32/wa32 ReadFile.vi"/>
			<Item Name="wa32 WaitNamedPipeA.vi" Type="VI" URL="../../../TWM - github/lvprog/server/WinAPI32/wa32 WaitNamedPipeA.vi"/>
			<Item Name="wa32 WriteFile.vi" Type="VI" URL="../../../TWM - github/lvprog/server/WinAPI32/wa32 WriteFile.vi"/>
		</Item>
		<Item Name="Build Specifications" Type="Build">
			<Item Name="QPSCONTROL" Type="EXE">
				<Property Name="App_copyErrors" Type="Bool">true</Property>
				<Property Name="App_INI_aliasGUID" Type="Str">{09C9D4D2-7977-4DFE-977E-42DFCCEB0475}</Property>
				<Property Name="App_INI_GUID" Type="Str">{9A172AA0-599F-4357-AE36-F7A82A32C0B2}</Property>
				<Property Name="App_serverConfig.httpPort" Type="Int">8002</Property>
				<Property Name="App_serverType" Type="Int">0</Property>
				<Property Name="Bld_buildCacheID" Type="Str">{0A2FAF75-9505-4362-8DF3-C88BEBACF02A}</Property>
				<Property Name="Bld_buildSpecName" Type="Str">QPSCONTROL</Property>
				<Property Name="Bld_excludeInlineSubVIs" Type="Bool">true</Property>
				<Property Name="Bld_excludeLibraryItems" Type="Bool">true</Property>
				<Property Name="Bld_excludePolymorphicVIs" Type="Bool">true</Property>
				<Property Name="Bld_localDestDir" Type="Path">../QPSCONTROL builds/QPSCONTROL [VersionNumber]</Property>
				<Property Name="Bld_localDestDirType" Type="Str">relativeToCommon</Property>
				<Property Name="Bld_modifyLibraryFile" Type="Bool">true</Property>
				<Property Name="Bld_previewCacheID" Type="Str">{D07E181F-3DCC-42DD-8E6A-23A4BE7CBC67}</Property>
				<Property Name="Bld_version.minor" Type="Int">4</Property>
				<Property Name="Destination[0].destName" Type="Str">QPSCONTROL.exe</Property>
				<Property Name="Destination[0].path" Type="Path">../QPSCONTROL builds/QPSCONTROL [VersionNumber]/NI_AB_PROJECTNAME.exe</Property>
				<Property Name="Destination[0].preserveHierarchy" Type="Bool">true</Property>
				<Property Name="Destination[0].type" Type="Str">App</Property>
				<Property Name="Destination[1].destName" Type="Str">Support Directory</Property>
				<Property Name="Destination[1].path" Type="Path">../QPSCONTROL builds/QPSCONTROL [VersionNumber]/data</Property>
				<Property Name="DestinationCount" Type="Int">2</Property>
				<Property Name="Source[0].itemID" Type="Str">{B0108AC1-920D-4093-A85B-289DF736FFDA}</Property>
				<Property Name="Source[0].type" Type="Str">Container</Property>
				<Property Name="Source[1].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[1].itemID" Type="Ref">/My Computer/GUI/GUI main.vi</Property>
				<Property Name="Source[1].sourceInclusion" Type="Str">TopLevel</Property>
				<Property Name="Source[1].type" Type="Str">VI</Property>
				<Property Name="SourceCount" Type="Int">2</Property>
				<Property Name="TgtF_companyName" Type="Str">Czech Metrology Institute</Property>
				<Property Name="TgtF_enableDebugging" Type="Bool">true</Property>
				<Property Name="TgtF_fileDescription" Type="Str">QPSCONTROL</Property>
				<Property Name="TgtF_internalName" Type="Str">QPSCONTROL</Property>
				<Property Name="TgtF_legalCopyright" Type="Str">Copyright © 2022 Czech Metrology Institute</Property>
				<Property Name="TgtF_productName" Type="Str">QPSCONTROL</Property>
				<Property Name="TgtF_targetfileGUID" Type="Str">{FCFB363C-3DA7-4115-9BF7-23E1B99E8B3A}</Property>
				<Property Name="TgtF_targetfileName" Type="Str">QPSCONTROL.exe</Property>
				<Property Name="TgtF_versionIndependent" Type="Bool">true</Property>
			</Item>
		</Item>
	</Item>
</Project>
