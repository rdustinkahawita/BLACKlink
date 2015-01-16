%% BBB GUI Function
function varargout = BBB_QuadRotor_GUI_Program_v4
% Close All Figures
close all;
clear all;
BBB_GUI=[];
BBB_GUI_Init_Data;
BBB_GUI_Construct_Fig;
BBB_GUI_Construct_VR;
BBB_GUI_Init_VR;
BBB_GUI_CheckState;

%EventListener_Scope_Attitude_Add;
%EventListener_Scope_Accel_Add;
%assignin('base','BBB_GUI_WS_Attitude',BBB_GUI.EventLstnrHandle.Attitude); % Try GUIData instead!
%assignin('base','BBB_GUI_WS_Accel',BBB_GUI.EventLstnrHandle.Acceleration); % Try GUIData instead!
%assignin('base','BBB_GUI_WS',BBB_GUI.q1);

varargout{1} = BBB_GUI.Figure;

%% Construct Figure
    function BBB_GUI_Construct_Fig                   
        %% Build Figure, W/ Configured Properties
        BBB_GUI.Figure = figure(...%'Tag',mfilename,...
        'Toolbar','none',...
        'MenuBar','none',...
        'IntegerHandle','off',...
        'Color',[0,0,0],...
        'Units','normalized',...
        'Position',[0.1 0.1, 0.8, 0.8],...
        'Resize','on',...
        'NumberTitle','off',...
        'HandleVisibility','callback',...
        'Name',sprintf('BLACKlink BeagleBone Black Attitude Estimation GUI. Model: %s.mdl',BBB_GUI.Model.ModelName),...
        'CloseRequestFcn',@Func_UI_Close,...
        'Visible','off');

        %Set Graphic Variables
        Figure_FontName='verdana';
        Figure_FontSize=10;
    
        %%   Create Accelerometer Panel
        BBB_GUI.Panel_Accel = uipanel('Parent',BBB_GUI.Figure,...
            'Units','normalized',...
            'Position',[0 0.416 0.5 0.416],...
            'Title',' Accelerometer Plot ',...
            'BackgroundColor',get(BBB_GUI.Figure,'Color'),...
            'ForegroundColor','r',...
            'FontName',Figure_FontName,...
            'FontSize',Figure_FontSize,...
            'HandleVisibility','callback',...
            'Tag','AccelAxesPanel');         
    
        % Create Accelerometer Axis
        BBB_GUI.Control.Axis_A = axes('Parent',BBB_GUI.Panel_Accel,...
            'HandleVisibility','callback',...
            'Unit','normalized',...
            'OuterPosition',[0 0 0.95 1],...
            'Xlim',[0 10],...
            'YLim',[-1 1],...     
            'XColor','w',...
            'YColor','w',...
            'FontName',Figure_FontName,...
            'FontSize',Figure_FontSize,...
            'Tag','AccelAxes',...
            'Color','none');
        title( BBB_GUI.Control.Axis_A,'Acceleration vs. Time');
        set(get(BBB_GUI.Control.Axis_A,'Title'),'Color','w');
        xlabel( BBB_GUI.Control.Axis_A,'Time (sec)');
        ylabel( BBB_GUI.Control.Axis_A,'Acceleration (g)');
        grid( BBB_GUI.Control.Axis_A,'on');
        box( BBB_GUI.Control.Axis_A,'on');
        %legend( BBB_GUI.Control.Axis_A,'X Accel', 'Y Accel', 'Z Accel');
       
        % Create Accelerometer Axis Control Buttons -  Start Plot
        uicontrol('Parent',BBB_GUI.Panel_Accel,...
            'Style','pushbutton',...
            'Units','normalized',...
            'Position',[0.87 0.48 0.12 0.1],...
            'BackgroundColor',get(BBB_GUI.Figure,'Color'),...
            'ForegroundColor','r',...
            'String','Enable Plot',...
            'Enable','On',...
            'FontName',Figure_FontName,...
            'FontSize',Figure_FontSize,...
            'Callback',@Func_CB_AccelPlotCtrl_On,...
            'HandleVisibility','callback',...
            'Tag','pbAccelPlotCtrl_On')
        
        % Create Accelerometer Axis Control Buttons -  Stop Plot
        uicontrol('Parent',BBB_GUI.Panel_Accel,...
            'Style','pushbutton',...
            'Units','normalized',...
            'Position',[0.87 0.28 0.12 0.1],...
            'BackgroundColor',get(BBB_GUI.Figure,'Color'),...
            'ForegroundColor','r',...
            'String','Disable Plot',...
            'Enable','Off',...
            'FontName',Figure_FontName,...
            'FontSize',Figure_FontSize,...
            'Callback',@Func_CB_AccelPlotCtrl_Off,...
            'HandleVisibility','callback',...
            'Tag','pbAccelPlotCtrl_Off')
        
        % Create Handles For Accelerometer Axis Lines
        Handle_Axis_A = BBB_GUI.Control.Axis_A;
        Handle_Axis_A_Lines=nan(1,3);
        % Create Handles To Axis Lines For Accelerometer Readings           
        % BBB_GUI.Control.Axis_A.LineHandles = nan(1,3);
        Axis_A_ColorOrder = get(Handle_Axis_A,'ColorOrder');
        for Axis_A_Line_Index = 1:length(Handle_Axis_A_Lines)
            Handle_Axis_A_Lines(Axis_A_Line_Index) = line('Parent',BBB_GUI.Control.Axis_A,...
                'XData',[],...
                'YData',[],...
                'Color',Axis_A_ColorOrder(mod(Axis_A_Line_Index-1,size(Axis_A_ColorOrder,1))+1,:),...
                'EraseMode','xor',...
                'Tag',sprintf('Axis_A_SignalLine_%d',Axis_A_Line_Index));
        end
        
             
        BBB_GUI.Control.Axis_A.LineHandles_1 = Handle_Axis_A_Lines(1);
        BBB_GUI.Control.Axis_A.LineHandles_2 = Handle_Axis_A_Lines(2);
        BBB_GUI.Control.Axis_A.LineHandles_3 = Handle_Axis_A_Lines(3);
                 
        %%   Create Gyro Panel
        BBB_GUI.Panel_Gyro = uipanel('Parent',BBB_GUI.Figure,...
            'Units','normalized',...
            'Position',[0.5 0.416 0.5 0.416],...
            'Title',' Gyroscope Plot ',...
            'BackgroundColor',get(BBB_GUI.Figure,'Color'),...
            'ForegroundColor','r',...
            'FontName',Figure_FontName,...
            'FontSize',Figure_FontSize,...
            'HandleVisibility','callback',...
            'Tag','GyroAxesPanel');
                
        % Create Gyro Axis
        BBB_GUI.Control.Axis_G = axes('Parent',BBB_GUI.Panel_Gyro,...
            'HandleVisibility','callback',...
            'Unit','normalized',...
            'OuterPosition',[0.0 0.0 0.95 1],...
            'Xlim',[0 10],...
            'YLim',[-1 1],...     
            'XColor','w',...
            'YColor','w',...
            'FontName',Figure_FontName,...
            'FontSize',Figure_FontSize,...
            'Tag','GyroAxes',...
            'Color','none');
        title( BBB_GUI.Control.Axis_G,'Rotational Velocity vs. Time');
        set(get(BBB_GUI.Control.Axis_G,'Title'),'Color','w');
        xlabel( BBB_GUI.Control.Axis_G,'Time (sec)');
        ylabel( BBB_GUI.Control.Axis_G,'Rotational Velocity (degrees)');
        grid( BBB_GUI.Control.Axis_G,'on');
        box( BBB_GUI.Control.Axis_G,'on');
  
         % Create Gyroscope Axis Control Buttons - Enable Plot
        uicontrol('Parent',BBB_GUI.Panel_Gyro,...
            'Style','pushbutton',...
            'Units','normalized',...
            'Position',[0.87 0.48 0.12 0.1],...
            'BackgroundColor',get(BBB_GUI.Figure,'Color'),...
            'ForegroundColor','r',...
            'String','Enable Plot',...
            'Enable','On',...
            'FontName',Figure_FontName,...
            'FontSize',Figure_FontSize,...
            'Callback',@Func_CB_GyroPlotCtrl_On,...
            'HandleVisibility','callback',...
            'Tag','pbGyroPlotCtrl_On')
        
        % Create Accelerometer Axis Control Buttons -  Stop Plot
        uicontrol('Parent',BBB_GUI.Panel_Gyro,...
            'Style','pushbutton',...
            'Units','normalized',...
            'Position',[0.87 0.28 0.12 0.1],...
            'BackgroundColor',get(BBB_GUI.Figure,'Color'),...
            'ForegroundColor','r',...
            'String','Disable Plot',...
            'FontName',Figure_FontName,...
            'FontSize',Figure_FontSize,...
            'Enable','Off',...
            'Callback',@Func_CB_GyroPlotCtrl_Off,...
            'HandleVisibility','callback',...
            'Tag','pbGyroPlotCtrl_Off')

        % Create Handles For Gyro Lines
        Handle_Axis_G = BBB_GUI.Control.Axis_G;
        Handle_Axis_G_Lines=nan(1,3);
        % Create Handles To Axis Lines For Gyroscope Readings           
        % BBB_GUI.Control.Axis_A.LineHandles = nan(1,3);
        Axis_G_ColorOrder = get(Handle_Axis_G,'ColorOrder');
        for Axis_G_Line_Index = 1:length(Handle_Axis_G_Lines)
            Handle_Axis_G_Lines(Axis_G_Line_Index) = line('Parent',BBB_GUI.Control.Axis_G,...
                'XData',[],...
                'YData',[],...
                'Color',Axis_G_ColorOrder(mod(Axis_G_Line_Index-1,size(Axis_G_ColorOrder,1))+1,:),...
                'EraseMode','xor',...
                'Tag',sprintf('Axis_G_SignalLine_%d',Axis_G_Line_Index));
        end
        
        % Transfer Handles To Global Data
        BBB_GUI.Control.Axis_G.LineHandles_1 = Handle_Axis_G_Lines(1);
        BBB_GUI.Control.Axis_G.LineHandles_2 = Handle_Axis_G_Lines(2);
        BBB_GUI.Control.Axis_G.LineHandles_3 = Handle_Axis_G_Lines(3);
      
        %%   Create VR Canvas Panel - Front View!
        BBB_GUI.Panel_AttitudeFV= uipanel('Parent',BBB_GUI.Figure,...
            'Units','normalized',...
            'Position',[0 0 0.5 0.416],...
            'Title','Attitude Estimate - Front View ',...
            'BackgroundColor',get(BBB_GUI.Figure,'Color'),...
            'ForegroundColor','r',...
            'FontName',Figure_FontName,...
            'FontSize',Figure_FontSize,...
            'HandleVisibility','callback',...
            'Tag','pnlAttitudeFVVR');

        %   Create VR Canvas Panel - Top View!
        BBB_GUI.Panel_AttitudeTV= uipanel('Parent',BBB_GUI.Figure,...
            'Units','normalized',...
            'Position',[0.5 0 0.5 0.416],...
            'Title',' Attitude Estimate - Top View ',...
            'BackgroundColor',get(BBB_GUI.Figure,'Color'),...
            'ForegroundColor','r',...
            'FontName',Figure_FontName,...
            'FontSize',Figure_FontSize,...
            'HandleVisibility','callback',...
            'Tag','pnlAttitudeTVVR');

        %%   Create Simulation Control Panel
        BBB_GUI.Panel_SimCntrl= uipanel('Parent',BBB_GUI.Figure,...
            'Units','normalized',...
            'Position',[0 0.83 0.4 0.168],...
            'Title',' Simulation Control Panel ',...
            'BackgroundColor',get(BBB_GUI.Figure,'Color'),...
            'ForegroundColor','r',...
            'FontName',Figure_FontName,...
            'FontSize',Figure_FontSize,...
            'HandleVisibility','callback',...
            'Tag','pnlSimCntrl');        
               
  
         % CreateSimulation Control Panel Buttons - Build Model
        uicontrol('Parent',BBB_GUI.Panel_SimCntrl,...
            'Style','pushbutton',...
            'Units','normalized',...
            'Position',[0.112 0.3 0.2 0.4],...
            'BackgroundColor',get(BBB_GUI.Figure,'Color'),...
            'ForegroundColor','r',...
            'String','Build Model',...
            'Enable','On',...
            'FontName',Figure_FontName,...
            'FontSize',Figure_FontSize,...
            'Callback',@Func_CB_ModelBuild,...
            'HandleVisibility','callback',...
            'Tag','pbModelBuild')  
        
         % CreateSimulation Control Panel Buttons - Start Model
        uicontrol('Parent',BBB_GUI.Panel_SimCntrl,...
            'Style','pushbutton',...
            'Units','normalized',...
            'Position',[0.364 0.3 0.2 0.4],...
            'BackgroundColor',get(BBB_GUI.Figure,'Color'),...
            'ForegroundColor','r',...
            'String','Start Model',...
            'Enable','Off',...
            'FontName',Figure_FontName,...
            'FontSize',Figure_FontSize,...
            'Callback',@Func_CB_ModelStart,...
            'HandleVisibility','callback',...
            'Tag','pbModelStart')
        
         % CreateSimulation Control Panel Buttons - Stop Model
        uicontrol('Parent',BBB_GUI.Panel_SimCntrl,...
            'Style','pushbutton',...
            'Units','normalized',...
            'Position',[0.604 0.3 0.2 0.4],...
            'BackgroundColor',get(BBB_GUI.Figure,'Color'),...
            'ForegroundColor','r',...
            'String','Stop Model',...
            'Enable','Off',...
            'FontName',Figure_FontName,...
            'FontSize',Figure_FontSize,...
            'Callback',@Func_CB_ModelStop,...
            'HandleVisibility','callback',...
            'Tag','pbModelStop')        
        
        %%   Create Simulation State Panel
        BBB_GUI.Panel_SimCntrl= uipanel('Parent',BBB_GUI.Figure,...
            'Units','normalized',...
            'Position',[0.402 0.83 0.39 0.168],...
            'Title',' Simulation State  ',...
            'BackgroundColor',get(BBB_GUI.Figure,'Color'),...
            'ForegroundColor','r',...
            'FontName',Figure_FontName,...
            'FontSize',Figure_FontSize,...
            'HandleVisibility','callback',...
            'Tag','pnlSimState'); 
 
        % Create Model Name Text Box Label
         BBB_GUI.Text_ModelNameLabel = uicontrol('Parent',BBB_GUI.Panel_SimCntrl,...
            'Style','text',...
            'Units','normalized',...
            'Position',[0.03 0.67 0.2 0.2],...
            'BackgroundColor',get(BBB_GUI.Figure,'Color'),...
            'ForegroundColor','r',...
            'String','Model Name: ',...
            'FontName',Figure_FontName,...
            'FontSize',Figure_FontSize,...
            'HorizontalAlignment','left',...
            'HandleVisibility','callback',...
            'Tag','txtModelNameLabel'); %#ok
        
        % Create Model Name Text Box
        BBB_GUI.Text_ModelName = uicontrol('Parent',BBB_GUI.Panel_SimCntrl,...
            'Style','edit',...
            'Units','normalized',...
            'Position',[0.02 0.3 0.51 0.4],...
            'String',sprintf('%s.mdl',BBB_GUI.Model.ModelName),...
            'Enable','inactive',...
            'Backgroundcolor','k',...
            'ForegroundColor','r',...
            'FontName',Figure_FontName,...
            'FontSize',Figure_FontSize,...
            'HandleVisibility','callback',...
            'Tag','textModelName'); %#ok
        
        % Create Simulation Time Text Box Label
         BBB_GUI.Text_SimTimeLabel = uicontrol('Parent',BBB_GUI.Panel_SimCntrl,...
            'Style','text',...
            'Units','normalized',...
            'Position',[0.55 0.75 0.12 0.25],...
            'BackgroundColor',get(BBB_GUI.Figure,'Color'),...
            'ForegroundColor','r',...
            'String','Simulation Time: ',...
            'HorizontalAlignment','left',...
            'FontName',Figure_FontName,...
            'FontSize',Figure_FontSize,...
            'HandleVisibility','callback',...
            'Tag','txtSimulationTimeLabel'); %#ok
        
        % Create Simulation Time Text Box
        BBB_GUI.Text_SimTime = uicontrol('Parent',BBB_GUI.Panel_SimCntrl,...
            'Style','edit',...
            'Units','normalized',...
            'Position',[0.55 0.3 0.13 0.4],...
            'String',sprintf('0.0'),...
            'Enable','inactive',...
            'Backgroundcolor','k',...
            'ForegroundColor','r',...
            'HorizontalAlignment','center',...
            'FontName',Figure_FontName,...
            'FontSize',Figure_FontSize,...
            'HandleVisibility','callback',...
            'Tag','txtSimulationTime'); %#ok
        
        % Create System Time Text Box Label
         BBB_GUI.Text_SysTimeLabel = uicontrol('Parent',BBB_GUI.Panel_SimCntrl,...
            'Style','text',...
            'Units','normalized',...
            'Position',[0.7 0.75 0.12 0.25],...
            'BackgroundColor',get(BBB_GUI.Figure,'Color'),...
            'ForegroundColor','r',...
            'String','System Time: ',...
            'HorizontalAlignment','left',...
            'FontName',Figure_FontName,...
            'FontSize',Figure_FontSize,...
            'HandleVisibility','callback',...
            'Tag','txtSystemTimeLabel'); %#ok
        
        % Create System Time Text Box
        BBB_GUI.Text_SysTime = uicontrol('Parent',BBB_GUI.Panel_SimCntrl,...
            'Style','edit',...
            'Units','normalized',...
            'Position',[0.7 0.3 0.13 0.4],...
            'String',sprintf('0.0'),...
            'Enable','inactive',...
            'Backgroundcolor','k',...
            'ForegroundColor','r',...
            'HorizontalAlignment','center',...
            'FontName',Figure_FontName,...
            'FontSize',Figure_FontSize,...
            'HandleVisibility','callback',...
            'Tag','txtSystemTime'); %#ok        

        % Create Lag Time Text Box Label
         BBB_GUI.Text_LagTimeLabel = uicontrol('Parent',BBB_GUI.Panel_SimCntrl,...
            'Style','text',...
            'Units','normalized',...
            'Position',[0.85 0.67 0.13 0.2],...
            'BackgroundColor',get(BBB_GUI.Figure,'Color'),...
            'ForegroundColor','r',...
            'String','Lag Time: ',...
            'HorizontalAlignment','left',...
            'FontName',Figure_FontName,...
            'FontSize',Figure_FontSize,...
            'HandleVisibility','callback',...
            'Tag','txtLagTimeLabel'); %#ok
        
        % Create Lag Time Text Box
        BBB_GUI.Text_LagTime = uicontrol('Parent',BBB_GUI.Panel_SimCntrl,...
            'Style','edit',...
            'Units','normalized',...
            'Position',[0.85 0.3 0.13 0.4],...
            'String','',...
            'Enable','inactive',...
            'BackgroundColor','k',...
            'ForegroundColor','r',...
            'HorizontalAlignment','center',...
            'FontName',Figure_FontName,...
            'FontSize',Figure_FontSize,...
            'HandleVisibility','callback',...
            'Tag','txtLagTime'); %#ok
        %set(BBB_GUI.Text_LagTime,'color','none');
        
        % Create Lag Time Text Box - Progress Bar
        BBB_GUI.Text_LagTimeProgBar = uicontrol('Parent',BBB_GUI.Panel_SimCntrl,...
            'Style','edit',...
            'Units','normalized',...
            'Position',[0.85 0.3 0.005 0.4],...
            'String','',...
            'Enable','inactive',...
            'Backgroundcolor','g',...
            'ForegroundColor','r',...
            'HorizontalAlignment','center',...
            'FontName',Figure_FontName,...
            'FontSize',Figure_FontSize,...
            'HandleVisibility','callback',...
            'Tag','txtLagTimeProgBar'); %#ok         
        
        
             
        %   Create BlackLink Logo Control Panel
        BBB_GUI.Text_Logo = uicontrol('Parent',BBB_GUI.Figure,...
            'Style','text',...
            'Units','normalized',...
            'Position',[0.8 0.83 0.2 0.12],...
            'BackgroundColor',get(BBB_GUI.Figure,'Color'),...
            'ForegroundColor',[1, 0.6, 0.0],...
            'FontSize', 40,...
            'FontWeight','bold',...
            'FontName','MS Sans Serif',...
            'HorizontalAlignment','center',...
            'String',' BLACKlink ',...
            'HandleVisibility','callback',...
            'Tag','txtLogo');

        %% GUI Final Setup
        % Create Handles Structure
        BBB_GUI.Handles = guihandles(BBB_GUI.Figure);
        
        % Save Application Data
         guidata(BBB_GUI.Figure,BBB_GUI);
         
        %Figure_Handles=findall(BBB_GUI.Figure) 
        %Object_Handles=findobj(BBB_GUI.Figure) 
        
        % Position the UI in the centre of the screen
        movegui(BBB_GUI.Figure,'center')
        
        % Make UI Visible
        set(BBB_GUI.Figure,'Visible','on');
    
    end

%% Function: Check Simulation State
    function BBB_GUI_CheckState

        % Load Model if Closed 
        if  isempty(find_system('Type','block_diagram','Name',BBB_GUI.Model.ModelName));
            load_system(BBB_GUI.Model.ModelName); %load_system
        end
        
        %%% RDK Check HERE
        
        % Get Simulation Execution State
        SimState = get_param(BBB_GUI.Model.ModelName,'SimulationStatus');
        
        % Enable / Disable Functionality Depending on Simulation State
        switch SimState
            case 'stopped'
                % Set Button Enable States
                % Disable "Start Model" Button
                set(BBB_GUI.Handles.pbModelStart,'Enable','off');
                % Disable "Stop Model" Button
                set(BBB_GUI.Handles.pbModelStop,'Enable','off');
                % Enable "Build Model" Button
                set(BBB_GUI.Handles.pbModelBuild,'Enable','on');
                % Disable "Enable Plot - Accel" Button
                set(BBB_GUI.Handles.pbAccelPlotCtrl_On,'Enable','off')                
                % Disable "Enable Plot - Gyro" Button 
                set(BBB_GUI.Handles.pbGyroPlotCtrl_On,'Enable','off')                
            case 'external'
                % Disable "Start Model" Button
                set(BBB_GUI.Handles.pbModelStart,'Enable','off');
                % Enable "Stop Model" Button
                set(BBB_GUI.Handles.pbModelStop,'Enable','on');
                % Disable "Build Model" Button
                set(BBB_GUI.Handles.pbModelBuild,'Enable','off');
                % Add Attitude Event Listener
                EventListener_Scope_Attitude_Add;
                % Scope Data To Workspace
                assignin('base','BBB_GUI_WS_Attitude',BBB_GUI.EventLstnrHandle.Attitude); % Try GUIData insteadr;         
            otherwise
                errordlg('Model Is Not In Recognized State. Stop Model and Relaunch UI',...
                    'UI Error - Model in Unrecognized State','modal');
        end        
    end

%% Function: Build Model 
    function Func_CB_ModelBuild(hObject,eventdata)
        % Build Model

        % Disable "Build Model" Button
        set(BBB_GUI.Handles.pbModelBuild,'Enable','off');
        
        % Configure Wait Bar Text
        BuildModel_WaitBar_String = sprintf('%s\n\n%s%s\n\n%s',...
            'Building Model:',strrep(BBB_GUI.Model.ModelName,'_','\_'),'... ',...
            'Please Be Patient As This Should Take Approximately a Minute. Cheers!');
        BuildModel_WaitBar = waitbar(0,BuildModel_WaitBar_String,...
            'Name','Building Model...   ');
        %Pause
        pause(0.1);
        % Animate WaitBar - For Fun
        for BuildModel_Time_Increment = 0:20
            % Pause
            %pause(BuildModel_Estimated_Waiting/1000);
            % Update WaitBar
            waitbar(BuildModel_Time_Increment/100,BuildModel_WaitBar,BuildModel_WaitBar_String,...
            'Name','Building Model...   ');
        end       
        
        % Set the Simulation Mode to External
        set_param(BBB_GUI.Model.ModelName,'SimulationMode','external');
        % Build the Model
        rtwbuild(BBB_GUI.Model.ModelName);
        % Estimated Build Waiting
        BuildModel_Estimated_Waiting=35;

        % Animate WaitBar - For Fun
        for BuildModel_Time_Increment = 20:100
            % Pause
            %pause(BuildModel_Estimated_Waiting/1000);
            % Update WaitBar
            waitbar(BuildModel_Time_Increment/100,BuildModel_WaitBar,BuildModel_WaitBar_String,...
            'Name','Building Model...   ');
        end
     
        % Reset the Simulation Mode
        % set_param(BBB_GUI.Model.ModelName,'SimulationMode','external');
        % Build Complete Delete the Waitbar
        delete(BuildModel_WaitBar);

        % Enable "Start Model" Button
        set(BBB_GUI.Handles.pbModelStart,'Enable','on');
        
        % Set Model Build Flag
        BBB_GUI.Model.BuildFlag=true;
        
        % Flush the Graphics Buffer
        %drawnow
    end

%% Function: Start Model 
    function Func_CB_ModelStart(hObject,eventdata)
        % Start Model
             
        % Load Model if Closed 
        if  isempty(find_system('Type','block_diagram','Name',BBB_GUI.Model.ModelName));
            load_system(BBB_GUI.Model.ModelName);
        end
              
        % Reset Plot Data Lines    
        set(BBB_GUI.Handles.Axis_A_SignalLine_1,'XData',[],'YData',[]);
        set(BBB_GUI.Handles.Axis_A_SignalLine_2,'XData',[],'YData',[]);
        set(BBB_GUI.Handles.Axis_A_SignalLine_3,'XData',[],'YData',[]);      
        set(BBB_GUI.Handles.Axis_G_SignalLine_1,'XData',[],'YData',[]);
        set(BBB_GUI.Handles.Axis_G_SignalLine_2,'XData',[],'YData',[]);
        set(BBB_GUI.Handles.Axis_G_SignalLine_3,'XData',[],'YData',[]);
                      
        % Set Simulation Stop Time To Inifinity 
        set_param(BBB_GUI.Model.ModelName,'StopTime','inf');
        % Set the Simulation Mode to External
        %set_param(BBB_GUI.Model.ModelName,'SimulationMode','external');
        % Start the GRT code
        % system(sprintf('%s -tf inf -w &',BBB_GUI.Model.ModelName));
        % Connect to the code
        set_param(BBB_GUI.Model.ModelName,'SimulationCommand','connect');
        % Start Model
        set_param(BBB_GUI.Model.ModelName,'SimulationCommand','start');

        % Start Measurement of System Time
        BBB_GUI.Time.System=tic;
        % Disable Start Button
        set(BBB_GUI.Handles.pbModelStart,'Enable','off');
        % Enable Stop button
        set(BBB_GUI.Handles.pbModelStop,'Enable','on');       
        % Enable "Enable Plot - Accel" Button
        set(BBB_GUI.Handles.pbAccelPlotCtrl_On,'Enable','on')
        % Enable "Enable Plot - Gyro" Button
        set(BBB_GUI.Handles.pbGyroPlotCtrl_On,'Enable','on')
        
        
        % Add Attitude Event Listener
        EventListener_Scope_Attitude_Add;
        % Scope Data To Workspace
        assignin('base','BBB_GUI_WS_Attitude',BBB_GUI.EventLstnrHandle.Attitude); % Try GUIData insteadr;
        
    end

%% Function: Stop Model 
    function Func_CB_ModelStop(hObject,eventdata)
        
              
        % Disable Stop Button
        set(BBB_GUI.Handles.pbModelStop,'Enable','off');
        % Enable Build Button
        set(BBB_GUI.Handles.pbModelBuild,'Enable','on');
        % Enable Start Button
        set(BBB_GUI.Handles.pbModelStart,'Enable','off');
        % Disable "Enable Plot - Accel" Button
        set(BBB_GUI.Handles.pbAccelPlotCtrl_On,'Enable','off')
        % Disable "Enable Plot - Gyro" Button
        set(BBB_GUI.Handles.pbGyroPlotCtrl_On,'Enable','off')    
        % Disable "Disable Plot - Accel" Button
        set(BBB_GUI.Handles.pbAccelPlotCtrl_Off,'Enable','off')
        % Disable "Disable Plot - Gyro" Button
        set(BBB_GUI.Handles.pbGyroPlotCtrl_Off,'Enable','off')          
        

        % Stop Model Simulation
        set_param(BBB_GUI.Model.ModelName,'SimulationCommand','stop');
        % Disconnect Model
        set_param(BBB_GUI.Model.ModelName,'SimulationCommand','disconnect');
        
        % Remove Attitude Event Listner (Not Required)
         delete(BBB_GUI.EventLstnrHandle.Attitude)
        
    end

%% Function: Acceleration Plot Control
    function Func_CB_AccelPlotCtrl_On(hObject,eventdata)
        % Call Function To Add Event Listener
        EventListener_Scope_Accel_Add;
    end

%% Function: Acceleration Plot Control
    function Func_CB_AccelPlotCtrl_Off(hObject,eventdata)
        % Call Function To Add Event Listener
        EventListener_Scope_Accel_Remove;
    end

%% Function: Gyroscope Plot Control
    function Func_CB_GyroPlotCtrl_On(hObject,eventdata)
        % Add Event Listener
        EventListener_Scope_Gyro_Add
    end

%% Function: Gyroscope Plot Control
    function Func_CB_GyroPlotCtrl_Off(hObject,eventdata)
        % Remove Event Listener
        EventListener_Scope_Gyro_Remove;
    end

%% Build VR Viewers
    function BBB_GUI_Construct_VR
        % Set VR Preferences
        vrsetpref('DefaultViewer', 'internalv5')
        % Obtain vrworld and construct canvas
        BBB_GUI.QR_VR_World = vrworld('.\Software_Quadrotor_VRML\BBB_Plane.WRL');
        open(BBB_GUI.QR_VR_World);
        %Create the VR Viewer Embedded in MATLAB GUI
        % set(BBB_GUI.Canvas,'Units','normalized')
        % BBB_GUI.Canvas = vr.canvas(BBB_GUI.QR_VR_World,BBB_GUI.Figure,[0 0 0.5 0.416]);
        
        % Configure Front View Viewer
        BBB_GUI.Canvas.Front = vr.canvas(BBB_GUI.QR_VR_World,'Parent',BBB_GUI.Figure,...
        'Units','normalized',...
        'Position',[0.01 0.01 0.48 0.386],...    
        'Viewpoint','Close Up View');
    
         % Configure Top View Viewer
         BBB_GUI.Canvas.Top = vr.canvas(BBB_GUI.QR_VR_World,'Parent',BBB_GUI.Figure,...
        'Units','normalized',...
        'Position',[0.51 0.01 0.48 0.386],...    
        'Viewpoint','Top View');
    end

%% Init VR Viewer Data
    function BBB_GUI_Init_VR
        %Accessing the vrnode to animate
        BBB_GUI.BBB_Aircraft_node=vrnode(BBB_GUI.QR_VR_World,'BBB_Aircraft');
        BBB_GUI.q1=0;
        BBB_GUI.q2=0;
        BBB_GUI.q3=0;
        BBB_GUI.q4=0;
    end

%% Init GUI Data 
    function BBB_GUI_Init_Data
        %Accessing the vrnode to animate
        BBB_GUI.Counter_1=0;
        BBB_GUI.Model.ModelName='BBB_AHRS_IMU_v4_Test_3DAnimation_HMI_Backup';
        BBB_GUI.Axis_A_YLim_New=1;
        BBB_GUI.Axis_G_YLim_New=1;
        BBB_GUI.Axis_C_YLim_New=1;
        
        % Get Simulation State
        
        % Set Model Build Flag
        BBB_GUI.Model.BuildFlag=false;
        
        %BBB_GUI.EventLstnrHandle.Attitude=[];
    end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callback Function for adding an event listener to the gain block
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function EventListener_Scope_Attitude_Add
        
        
        ScopeName=sprintf('%s/Scope_Attitude',BBB_GUI.Model.ModelName);
        
        % Add Listener For Aircraft Attitude Data Change
        BBB_GUI.EventLstnrHandle.Attitude=add_exec_event_listener(ScopeName,...
            'PostOutputs',@EventListener_Scope_Attitude_Func);

    end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callback Function for executing the event listener on the gain block
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function EventListener_Scope_Attitude_Func(block, eventdata) %#ok
        
        % Note: This callback is called by all the block listeners.  No effort has
        % been made to time synchronise the data from each signal.  Rather it is
        % assumed that since each block calls this function at every time step and
        % hence the time synchronisation will come "for free".  This may not be the
        % case for other models and additional code may be required for them to
        % work/display data correctly.
       
        % disp('Trigger?')
        % Read Data From Attitude Scope
        ScopeData=block.InputPort(1).Data;
        BBB_GUI.q1=ScopeData(1);
        BBB_GUI.q2=ScopeData(2);
        BBB_GUI.q3=ScopeData(3);
        BBB_GUI.q4=ScopeData(4);
        %BBB_GUI.q2=block.InputPort(2).Data
        %BBB_GUI.q3=block.InputPort(3).Data
        %BBB_GUI.q4=block.InputPort(4).Data
        
        % Update Aircraft Aittitude in VR World
        
        BBB_GUI.BBB_Aircraft_node.rotation=[BBB_GUI.q1 BBB_GUI.q2 BBB_GUI.q3 BBB_GUI.q4];
        
        % Update VR Images
        vrdrawnow;
        %drawnow;
        
        % Update Simulation Time
        set(BBB_GUI.Handles.txtSimulationTime,'String',get_param(BBB_GUI.Model.ModelName,'SimulationTime'));
        
        % Update System Time
         set(BBB_GUI.Handles.txtSystemTime,'String',toc(BBB_GUI.Time.System)); 
        
        % Illustrate Lag Time On Progress Bar
        % Calculate LagTime - Max Bar Out If Lag Time > 60
        LagTime=abs(get_param(BBB_GUI.Model.ModelName,'SimulationTime')-toc(BBB_GUI.Time.System))/60;
        % Set Lag Time Max
        if LagTime>1
            LagTime=1;
        end
        % Display Lag Time Bar
        set(BBB_GUI.Handles.txtLagTimeProgBar,'Position',[0.85 0.3 LagTime*0.13 0.4]); 
        % Display Lag Time When Space Adequate % 'Position',[0.85 0.3 0.005 0.4],...
        if LagTime>0.2
            set(BBB_GUI.Handles.txtLagTimeProgBar,'String',num2str(LagTime*60));
        end
         
    end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callback Function for adding an event listener to the gain block
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function EventListener_Scope_Accel_Add
        
        
        ScopeName=sprintf('%s/Scope_Accel',BBB_GUI.Model.ModelName);
        
        % Add Listener For Aircraft Attitude Data Change
        BBB_GUI.EventLstnrHandle.Acceleration=add_exec_event_listener(ScopeName,...
            'PostOutputs',@EventListener_Scope_Accel_Func);
        
        % Disable "Enable Plot" Button
        set(BBB_GUI.Handles.pbAccelPlotCtrl_On,'Enable','off');
        
        % Enable "Disable Plot" Button
        set(BBB_GUI.Handles.pbAccelPlotCtrl_Off,'Enable','on');   
        
        % Trigger Bit
        BBB_GUI.EventLstnrHandle.Trigger_A=false;

    end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callback Function For Removing Event Listener on Accelerometer Scope Block
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function EventListener_Scope_Accel_Remove
        
        
        delete(BBB_GUI.EventLstnrHandle.Acceleration);
        
        % Disable "Disable Plot" Button
        set(BBB_GUI.Handles.pbAccelPlotCtrl_Off,'Enable','off');

        % Enable "Enable Plot" Button
        set(BBB_GUI.Handles.pbAccelPlotCtrl_On,'Enable','on');        
        
    end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callback Function for adding an event listener to the gain block
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function EventListener_Scope_Gyro_Add
        
        
        ScopeName=sprintf('%s/Scope_Gyro',BBB_GUI.Model.ModelName);
        
        % Add Listener For Aircraft Attitude Data Change
        BBB_GUI.EventLstnrHandle.Gyroscope=add_exec_event_listener(ScopeName,...
            'PostOutputs',@EventListener_Scope_Gyro_Func);
            
        % Disable "Enable Plot" Button
        set(BBB_GUI.Handles.pbGyroPlotCtrl_On,'Enable','off');
        
        % Enable "Disable Plot" Button
        set(BBB_GUI.Handles.pbGyroPlotCtrl_Off,'Enable','on');        

        % Trigger Bit
        BBB_GUI.EventLstnrHandle.Trigger_G=false;
        
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callback Function For Removing Event Listener on Gyroscope Scope Block
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function EventListener_Scope_Gyro_Remove
        
        
        delete(BBB_GUI.EventLstnrHandle.Gyroscope);
        
        % Disable "Disable Plot" Button
        set(BBB_GUI.Handles.pbGyroPlotCtrl_Off,'Enable','off');

        % Enable "Enable Plot" Button
        set(BBB_GUI.Handles.pbGyroPlotCtrl_On,'Enable','on');
        
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callback Function For Gyro Event Listener Gyroscope Scope Block
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function EventListener_Scope_Gyro_Func(block, eventdata) %#ok
                 
        Handle_Figure=guidata(BBB_GUI.Figure);
        Handle_Axis_G = BBB_GUI.Control.Axis_G;
        Handle_Axis_G_Line_1=BBB_GUI.Control.Axis_G.LineHandles_1;
        Handle_Axis_G_Line_2=BBB_GUI.Control.Axis_G.LineHandles_2;
        Handle_Axis_G_Line_3=BBB_GUI.Control.Axis_G.LineHandles_3;     
        
        % Get the data currently being displayed on the axis
        Scope_Xdata = get(Handle_Axis_G_Line_1,'XData');
        Scope_Ydata_Gyro_X = get(Handle_Axis_G_Line_1,'YData');
        Scope_Ydata_Gyro_Y = get(Handle_Axis_G_Line_2,'YData');
        Scope_Ydata_Gyro_Z = get(Handle_Axis_G_Line_3,'YData');
        
        % Get the simulation time and the block data
        Scope_Time = block.CurrentTime;

        % Read Data From Gyro Scope
        ScopeData=block.InputPort(1).Data;
        Scope_Gyro_X=ScopeData(1);
        Scope_Gyro_Y=ScopeData(2);
        Scope_Gyro_Z=ScopeData(3);
               
        
        % Only the last 1001 points worth of data
        % The model sample time is 0.001 so this represents 1000 seconds of data
        % RDK - Here current time is appended to X Data
        % RDK - Here current data from input port(1) is appended to Y Data
        if length(Scope_Xdata) < 1001
            Scope_Xdata_New = [Scope_Xdata Scope_Time];
            Scope_Ydata_Gyro_X_New = [Scope_Ydata_Gyro_X Scope_Gyro_X];
            Scope_Ydata_Gyro_Y_New = [Scope_Ydata_Gyro_Y Scope_Gyro_Y];
            Scope_Ydata_Gyro_Z_New = [Scope_Ydata_Gyro_Z Scope_Gyro_Z];
        else
            Scope_Xdata_New = [Scope_Xdata(2:end) Scope_Time];
            Scope_Ydata_Gyro_X_New = [Scope_Ydata_Gyro_X(2:end) Scope_Gyro_X];
            Scope_Ydata_Gyro_Y_New = [Scope_Ydata_Gyro_Y(2:end) Scope_Gyro_Y];
            Scope_Ydata_Gyro_Z_New = [Scope_Ydata_Gyro_Z(2:end) Scope_Gyro_Z];
        end
        
        % Display the new data set
        set(Handle_Axis_G_Line_1,...
            'XData',Scope_Xdata_New,...
            'YData',Scope_Ydata_Gyro_X_New);
        
        
        set(Handle_Axis_G_Line_2,...
            'XData',Scope_Xdata_New,...
            'YData',Scope_Ydata_Gyro_Y_New);
        
        
        set(Handle_Axis_G_Line_3,...
            'XData',Scope_Xdata_New,...
            'YData',Scope_Ydata_Gyro_Z_New)
        
        % The axes limits may also need changing
        Scope_XLim_New = [max(0,Scope_Time-10) max(10,Scope_Time)];
        Scope_YLim_Data_Array=[Scope_Gyro_X,Scope_Gyro_Y,Scope_Gyro_Z];
        Scope_YMax = max(abs(Scope_YLim_Data_Array));
        
        if Scope_YMax>BBB_GUI.Axis_G_YLim_New
            % Update Max
            Scope_YLim_New = Scope_YMax*[-1,1];
            BBB_GUI.Axis_G_YLim_New=Scope_YMax;
        else
            % Keep Old Max 
            Scope_YLim_New = BBB_GUI.Axis_G_YLim_New*[-1,1];           
        end
        
        % RDK - Note that will need to apply this to Y - Axis as well
        set(BBB_GUI.Handles.GyroAxes,'Xlim',Scope_XLim_New);
        set(BBB_GUI.Handles.GyroAxes,'Ylim',Scope_YLim_New);
    
        % Transfer Data Back To Handles?
        %BBB_GUI.Control.Axis_G.LineHandles_1=Handle_Axis_G_Line_1;
        %BBB_GUI.Control.Axis_G.LineHandles_2=Handle_Axis_G_Line_2;
        %BBB_GUI.Control.Axis_G.LineHandles_3=Handle_Axis_G_Line_3;
        
        % Add Legend To Graph
        if BBB_GUI.EventLstnrHandle.Trigger_G == false
           
           BBB_GUI.Control.Axis_G.Legend=legend(BBB_GUI.Handles.GyroAxes,'X Rot', 'Y Rot', 'Z Rot');
           set(BBB_GUI.Control.Axis_G.Legend,'TextColor','w'); 
           set(BBB_GUI.Control.Axis_G.Legend,'EdgeColor','r');
           set(BBB_GUI.Control.Axis_G.Legend,'Color','none');
           BBB_GUI.EventLstnrHandle.Trigger_G=true; 
        end      
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callback Function For Accelerometer Event Listener on Accelerometer Scope Block
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function EventListener_Scope_Accel_Func(block, eventdata) %#ok
                 
        Handle_Figure=guidata(BBB_GUI.Figure);
        Handle_Axis_A = BBB_GUI.Control.Axis_A;
        Handle_Axis_A_Line_1=BBB_GUI.Control.Axis_A.LineHandles_1;
        Handle_Axis_A_Line_2=BBB_GUI.Control.Axis_A.LineHandles_2;
        Handle_Axis_A_Line_3=BBB_GUI.Control.Axis_A.LineHandles_3;     
        
        % Get the data currently being displayed on the axis
        Scope_Xdata = get(Handle_Axis_A_Line_1,'XData');
        Scope_Ydata_Accel_X = get(Handle_Axis_A_Line_1,'YData');
        Scope_Ydata_Accel_Y = get(Handle_Axis_A_Line_2,'YData');
        Scope_Ydata_Accel_Z = get(Handle_Axis_A_Line_3,'YData');
        
        % Get the simulation time and the block data
        Scope_Time = block.CurrentTime;

        % Read Data From Attitude Scope
        ScopeData=block.InputPort(1).Data;
        Scope_Accel_X=ScopeData(1);
        Scope_Accel_Y=ScopeData(2);
        Scope_Accel_Z=ScopeData(3);
               
        
        % Only the last 1001 points worth of data
        % The model sample time is 0.001 so this represents 1000 seconds of data
        % RDK - Here current time is appended to X Data
        % RDK - Here current data from input port(1) is appended to Y Data
        if length(Scope_Xdata) < 1001
            Scope_Xdata_New = [Scope_Xdata Scope_Time];
            Scope_Ydata_Accel_X_New = [Scope_Ydata_Accel_X Scope_Accel_X];
            Scope_Ydata_Accel_Y_New = [Scope_Ydata_Accel_Y Scope_Accel_Y];
            Scope_Ydata_Accel_Z_New = [Scope_Ydata_Accel_Z Scope_Accel_Z];
        else
            Scope_Xdata_New = [Scope_Xdata(2:end) Scope_Time];
            Scope_Ydata_Accel_X_New = [Scope_Ydata_Accel_X(2:end) Scope_Accel_X];
            Scope_Ydata_Accel_Y_New = [Scope_Ydata_Accel_Y(2:end) Scope_Accel_Y];
            Scope_Ydata_Accel_Z_New = [Scope_Ydata_Accel_Z(2:end) Scope_Accel_Z];
        end
        
        % Display the new data set
        set(Handle_Axis_A_Line_1,...
            'XData',Scope_Xdata_New,...
            'YData',Scope_Ydata_Accel_X_New);
        
        
        set(Handle_Axis_A_Line_2,...
            'XData',Scope_Xdata_New,...
            'YData',Scope_Ydata_Accel_Y_New);
        
        
        set(Handle_Axis_A_Line_3,...
            'XData',Scope_Xdata_New,...
            'YData',Scope_Ydata_Accel_Z_New)
        
        % The axes limits may also need changing
        Scope_XLim_New = [max(0,Scope_Time-10) max(10,Scope_Time)];
        Scope_YLim_Data_Array=[Scope_Accel_X,Scope_Accel_Y,Scope_Accel_Z];
        Scope_YMax = max(abs(Scope_YLim_Data_Array));
        
        if Scope_YMax>BBB_GUI.Axis_A_YLim_New
            % Update Max
            Scope_YLim_New = Scope_YMax*[-1,1];
            BBB_GUI.Axis_A_YLim_New=Scope_YMax;
        else
            % Keep Old Max 
            Scope_YLim_New = BBB_GUI.Axis_A_YLim_New*[-1,1];           
        end
        
        % RDK - Note that will need to apply this to Y - Axis as well
        set(BBB_GUI.Handles.AccelAxes,'Xlim',Scope_XLim_New);
        set(BBB_GUI.Handles.AccelAxes,'Ylim',Scope_YLim_New);
    
        % Transfer Data Back To Handles?
        %BBB_GUI.Control.Axis_A.LineHandles_1=Handle_Axis_A_Line_1;
        %BBB_GUI.Control.Axis_A.LineHandles_2=Handle_Axis_A_Line_2;
        %BBB_GUI.Control.Axis_A.LineHandles_3=Handle_Axis_A_Line_3;
        
        % Add Legend To Graph
        if BBB_GUI.EventLstnrHandle.Trigger_A == false
           
           BBB_GUI.Control.Axis_A.Legend=legend(BBB_GUI.Handles.AccelAxes,'X Accel', 'Y Accel', 'Z Accel');
           set(BBB_GUI.Control.Axis_A.Legend,'TextColor','w'); 
           set(BBB_GUI.Control.Axis_A.Legend,'EdgeColor','r');
           set(BBB_GUI.Control.Axis_A.Legend,'Color','none');
           BBB_GUI.EventLstnrHandle.Trigger_A=true; 
        end        
        
        
        
    
    
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callback Function For UI Close 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function Func_UI_Close(hObject,eventdata) %#ok
        
        % Close UI If Not Model Loaded
        if  isempty(find_system('Type','block_diagram','Name',BBB_GUI.Model.ModelName));
            % Delete Window
            delete(gcbo);
        else
            % Only Allow UI Close if Simuation Model Has Been Stopped
            
            % Get Simulation Execution State
            SimState = get_param(BBB_GUI.Model.ModelName,'SimulationStatus');
            
            % Enable / Disable Functionality Depending on Simulation State
            switch SimState
                case 'stopped'
                    % Allow UI To Close
                    %Close the Simulink model
                    close_system(BBB_GUI.Model.ModelName,0);
                    % destroy the window
                    delete(gcbo);
                otherwise
                    errordlg('The Model Must Be Stopped Before Closing The UI',...
                        'UI Close Error','modal');
            end
            
            
        end
    end
end


        