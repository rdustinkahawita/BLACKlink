function varargout = BBB_QuadRotor_GUI_v1(varargin)
close all;
BBB_GUI=[];
% BBB_QUADROTOR_GUI_V1 MATLAB code for BBB_QuadRotor_GUI_v1.fig
%      BBB_QUADROTOR_GUI_V1, by itself, creates a new BBB_QUADROTOR_GUI_V1 or raises the existing
%      singleton*.
%
%      H = BBB_QUADROTOR_GUI_V1 returns the handle to a new BBB_QUADROTOR_GUI_V1 or the handle to
%      the existing singleton*.
%
%      BBB_QUADROTOR_GUI_V1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BBB_QUADROTOR_GUI_V1.M with the given input arguments.
%
%      BBB_QUADROTOR_GUI_V1('Property','Value',...) creates a new BBB_QUADROTOR_GUI_V1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BBB_QuadRotor_GUI_v1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BBB_QuadRotor_GUI_v1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BBB_QuadRotor_GUI_v1

% Last Modified by GUIDE v2.5 05-Sep-2014 19:59:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BBB_QuadRotor_GUI_v1_OpeningFcn, ...
                   'gui_OutputFcn',  @BBB_QuadRotor_GUI_v1_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% Declare Variables
%close all;
%BBB_GUI=[];
%BBB_GUI_Construct_Fig;
%BBB_GUI_Construct_VR;
%BBB_GUI_Init_VR;
%BBB_GUI_Init_Data;

% --- Executes just before BBB_QuadRotor_GUI_v1 is made visible.
function BBB_QuadRotor_GUI_v1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BBB_QuadRotor_GUI_v1 (see VARARGIN)

% Choose default command line output for BBB_QuadRotor_GUI_v1
handles.output = hObject;
handles.q1=0;
handles.q2=0;
handles.q3=0;
handles.q4=0;
handles.Counter_1=0;
handles.

% Update handles structure - Storage
guidata(hObject, handles);


%vrBBB_QuadRotor_Init;
% BBB_GUI_Construct_Fig;
BBB_GUI_Construct_VR;
BBB_GUI_Init_VR;
BBB_GUI_Init_Data;

% UIWAIT makes BBB_QuadRotor_GUI_v1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = BBB_QuadRotor_GUI_v1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pbTest1.
    function pbTest1_Callback(hObject, eventdata, handles)
        % hObject    handle to pbTest1 (see GCBO)
        % eventdata  reserved - to be defined in a future version of MATLAB
        % handles    structure with handles and user data (see GUIDATA)
        while  handles.Counter_1<200
            
            handles.q1=0;
            handles.q2=0;
            handles.q3=1;
            handles.q4=handles.q4+0.1;
            handles.BBB_Aircraft_node.rotation=[handles.q1 handles.q2 handles.q3 handles.q4];
            
            % Update Images
            vrdrawnow;
            drawnow;
            
            % Increment Counter
            handles.Counter_1= handles.Counter_1+1
        end

    
%% Construct Figure
%    function BBB_GUI_Construct_Fig
%        % Build Overall Figure
%        BBB_GUI.figure=figure('units','normalized',...
%                        'position',[0.1 0.1,0.8 0.8]);
    
       
%% Build VR Viewer
    function BBB_GUI_Construct_VR(handles)
        % Set VR Preferences
        vrsetpref('DefaultViewer', 'internalv5')
        % Obtain vrworld and construct canvas
        QR_VR_World = vrworld('.\Software_Quadrotor_VRML\BBB_Plane.WRL');
        open(QR_VR_World);
        %Create the VR Viewer Embedded in MATLAB GUI
        Canvas = vr.canvas(BBB_GUI.QR_VR_World,gcf,[20 10 400 400]);
        set(Canvas,'Units','normalized')
        Canvas.Viewpoint='Close Up View';
        
    

%% Init VR Viewer
    function BBB_GUI_Init_VR
        %Accessing the vrnode to animate
        BBB_GUI.BBB_Aircraft_node=vrnode(BBB_GUI.QR_VR_World,'BBB_Aircraft');
        BBB_GUI.q1=0;
        BBB_GUI.q2=0;
        BBB_GUI.q3=0;
        BBB_GUI.q4=0;
    

%% Init VR Viewer
    function BBB_GUI_Init_Data
        %Accessing the vrnode to animate
        BBB_GUI.Counter_1=0;
      

% function vrBBB_QuadRotor
%     % Set the viewer preference
%     vrsetpref('DefaultViewer', 'internalv5')
% 
%     % Obtain vrworld and construct canvas
%     QR_VR_World = vrworld('.\Software_Quadrotor_VRML\BBB_Plane.WRL');
%     open(QR_VR_World);
% 
%     %Create the MATLAB GUI with two views of the robot
%     c1 = vr.canvas(QR_VR_World,gcf,[20 10 400 400]);
%     set(c1,'Units','normalized')
%     c1.Viewpoint='Close Up View';
% 
% 
% function vrBBB_QuadRotor_Init
%         %Accessing the vrnode to animate
%             BBB_Aircraft_node=vrnode(QR_VR_World,'BBB_Aircraft');
%             q1=0;
%             q2=0;
%             q3=0;
%             q4=0;

    
    %% adding the virtual scene
    % vrsetpref('DefaultViewer','internalv5','DefaultFigureMaxTextureSize',32);
    % S.h.planar_robot_vr=vrworld('.\VRML_files\Robot_planar_RR_march_21.wrl');
    % open(S.h.planar_robot_vr);

    % S.h.Launcher_vr_canvas=vr.canvas(S.h.planar_robot_vr,...
    % 'Parent',S.h.figure,...
    % 'Units','normalized',...
    % 'Position',[0.03 0.4 0.44 0.55]);

    
    %% Data From JDD - RDK Program
%     function construct_figure
%         %Construction of the figure
%         S.h.figure=figure('units','normalized',...
%             'position',[0.1 0.1,0.8 0.8]);
%         
%         %adding the virtual scene
%         vrsetpref('DefaultViewer','internalv5','DefaultFigureMaxTextureSize',32);
%         S.h.planar_robot_vr=vrworld('.\VRML_files\Robot_planar_RR_march_21.wrl');
%         open(S.h.planar_robot_vr);
% 
%         S.h.Launcher_vr_canvas=vr.canvas(S.h.planar_robot_vr,...
%                 'Parent',S.h.figure,...
%                 'Units','normalized',...
%                 'Position',[0.03 0.4 0.44 0.55]);
%             
%         %dynamics_axes
%         S.h.dynamic_axes=axes('units','normalized',...
%             'position',[0.52 0.4 0.44 0.55],...
%             'xlim',[-0.2 1],'ylim',[-1,0]);
%         hold on
%         
%         %Cartesian trajectory axe
%         S.h.cartesian_trajectory_axes=axes('units','normalized',...
%             'position',[0.2 0.05 0.35 0.3],...
%             'xlim',[0 3],'ylim',[-0.8 0.8]);
%         hold on
%         title('Task space')
%         xlabel('time[s]');
%         ylabel('position[m]');
%         
%         
%         %articular trajectory axes
%         S.h.articular_trajectory_axes=axes('units','normalized',...
%             'position',[0.6 0.05 0.35 0.3],...
%             'xlim',[0 3],'ylim',[-2.5,0.5]);
%         hold on
%         title('Joint space')
%         xlabel('time[s]');
%         ylabel('joint value[rad]');
%         
%         %Play button
%         S.h.play_button=uicontrol('style','pushbutton',...
%             'units','normalized',...
%             'position',[0.05 0.2 0.1 0.05],...
%             'string','Play',...
%             'callback',{@play_pushbutton_callback});
%         
%         %popupmenu to select data
%         S.h.catesian_trajectory_popupmenu=uicontrol('style','popupmenu',...
%             'units','normalized',...
%             'position',[0.2 0.33 0.1 0.05],...
%             'string','Position|velocity|aceleration',...
%             'callback',{@cartesian_trajectory_popupmenu_callback});
%         
%         S.h.articular_trajectory_popupmenu=uicontrol('style','popupmenu',...
%             'units','normalized',...
%             'position',[0.6 0.33 0.1 0.05],...
%             'string','joint value|joint velocity|joint aceleration',...
%             'callback',{@articular_trajectory_popupmenu_callback});
%         
%         %popupmenu to select controllers
%         S.h.control_popupmenu=uicontrol('style','popupmenu',...
%             'units','normalized',...
%             'position',[0.05 0.15 0.1 0.03],...
%             'String','Desired motion|8.2    Feedback Linearization Inverse Dynamics Controller|8.3.2 Adaptive Inverse Dynamics|8.4    Passivity-Based Motion Control|8.4.1 Passivity-Based Robust Control|8.4.2 Passivity-Based Adaptive Control',...
%             'callback',{@controller_popupmenu_callback});
%         %popupmenu to select the real model value
%         S.h.model_popupmenu=uicontrol('style','popupmenu',...
%             'units','normalized',...
%             'position',[0.05 0.11 0.1 0.03],...
%             'String','Initial model|Model after perturbation');
%     end
%
%     function initialise_vrworld
%         %Accessing the vrnode to animate
%             S.vrnode.link1_node=vrnode(S.h.planar_robot_vr,'Link_1');
%             S.vrnode.link2_node=vrnode(S.h.planar_robot_vr,'Link_2');
%             
%             
%             update_vrworld;
%     end
%     
%
% function update_vrworld
%         switch get(S.h.control_popupmenu,'value')
%             case 1
%                 S.vrnode.link1_node.rotation=[0 0 1 S.trajectory.desired_q(1)];
%                 S.vrnode.link2_node.rotation=[0 0 1 S.trajectory.desired_q(2)];
%             otherwise
%                 S.vrnode.link1_node.rotation=[0 0 1 S.real_model.q(1)];
%                 S.vrnode.link2_node.rotation=[0 0 1 S.real_model.q(2)];
%                 
%         end
%         vrdrawnow;
%     end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
