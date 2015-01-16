function varargout = BBB_QuadRotor_GUI_v2(varargin)
% BBB_QUADROTOR_GUI_V2 MATLAB code for BBB_QuadRotor_GUI_v2.fig
%      BBB_QUADROTOR_GUI_V2, by itself, creates a new BBB_QUADROTOR_GUI_V2 or raises the existing
%      singleton*.
%
%      H = BBB_QUADROTOR_GUI_V2 returns the handle to a new BBB_QUADROTOR_GUI_V2 or the handle to
%      the existing singleton*.
%
%      BBB_QUADROTOR_GUI_V2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BBB_QUADROTOR_GUI_V2.M with the given input arguments.
%
%      BBB_QUADROTOR_GUI_V2('Property','Value',...) creates a new BBB_QUADROTOR_GUI_V2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BBB_QuadRotor_GUI_v2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BBB_QuadRotor_GUI_v2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BBB_QuadRotor_GUI_v2

% Last Modified by GUIDE v2.5 05-Sep-2014 10:50:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BBB_QuadRotor_GUI_v2_OpeningFcn, ...
                   'gui_OutputFcn',  @BBB_QuadRotor_GUI_v2_OutputFcn, ...
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


% --- Executes just before BBB_QuadRotor_GUI_v2 is made visible.
function BBB_QuadRotor_GUI_v2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BBB_QuadRotor_GUI_v2 (see VARARGIN)

% Choose default command line output for BBB_QuadRotor_GUI_v2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BBB_QuadRotor_GUI_v2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = BBB_QuadRotor_GUI_v2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
