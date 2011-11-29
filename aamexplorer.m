function varargout = aamexplorer(varargin)
% AAMEXPLORER MATLAB code for aamexplorer.fig
%      AAMEXPLORER, by itself, creates a new AAMEXPLORER or raises the existing
%      singleton*.
%
%      H = AAMEXPLORER returns the handle to a new AAMEXPLORER or the handle to
%      the existing singleton*.
%
%      AAMEXPLORER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AAMEXPLORER.M with the given input arguments.
%
%      AAMEXPLORER('Property','Value',...) creates a new AAMEXPLORER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before aamexplorer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to aamexplorer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help aamexplorer

% Last Modified by GUIDE v2.5 28-Nov-2011 21:26:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
  'gui_Singleton',  gui_Singleton, ...
  'gui_OpeningFcn', @aamexplorer_OpeningFcn, ...
  'gui_OutputFcn',  @aamexplorer_OutputFcn, ...
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


% --- Executes just before aamexplorer is made visible.
function aamexplorer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to aamexplorer (see VARARGIN)

% Variables: mshape, mgray, Qshape, Qgray, sigma2c, dimensions, [c]
if size(varargin,2) < 6 && isstruct(varargin{1})
  handles.model = varargin{1};
  if size(varargin,2) > 1
    handles.model.c = varargin{2};
    set(handles.buttoninitial, 'Enable', 'on');
  end
elseif size(varargin,2) >= 6
  handles.model.mshape = varargin{1};
  handles.model.mgray = varargin{2};
  handles.model.Qshape = varargin{3};
  handles.model.Qgray = varargin{4};
  handles.model.sigma2c = varargin{5};
  handles.model.dimensions = varargin{6};
  if size(varargin,2) > 6
    handles.model.c = varargin{7};
    set(handles.buttoninitial, 'Enable', 'on');
  end
else
  error('AAMexplorer:nomodel', 'No active appearance model given.');
end

% GUI state
handles.state.cursor = fix(handles.model.dimensions ./ 2);

% 2-D plots initialization
colormap('gray');

handles.imagexy = image('Parent', handles.axesxy, 'CDataMapping', 'scaled');
handles.cursorxy1 = line('Parent', handles.axesxy, 'Color', [.4 .8 1], 'LineStyle', ':', 'XLimInclude', 'off', 'YLimInclude', 'off');
handles.cursorxy2 = line('Parent', handles.axesxy, 'Color', [.4 .8 1], 'LineStyle', ':', 'XLimInclude', 'off', 'YLimInclude', 'off');
set(handles.axesxy, 'YDir', 'normal', 'XDir', 'reverse', 'NextPlot', 'add', 'CLim', [-450 1050], 'CLimInclude', 'off');
handles.contourxy = 0;

handles.imageyz = image('Parent', handles.axesyz, 'CDataMapping', 'scaled');
handles.cursoryz1 = line('Parent', handles.axesyz, 'Color', [.4 .8 1], 'LineStyle', ':', 'XLimInclude', 'off', 'YLimInclude', 'off');
handles.cursoryz2 = line('Parent', handles.axesyz, 'Color', [.4 .8 1], 'LineStyle', ':', 'XLimInclude', 'off', 'YLimInclude', 'off');
set(handles.axesyz, 'YDir', 'normal', 'XDir', 'reverse', 'NextPlot', 'add', 'CLim', [-450 1050], 'CLimInclude', 'off');
handles.contouryz = 0;

handles.imagexz = image('Parent', handles.axesxz, 'CDataMapping', 'scaled');
handles.cursorxz1 = line('Parent', handles.axesxz, 'Color', [.4 .8 1], 'LineStyle', ':', 'XLimInclude', 'off', 'YLimInclude', 'off');
handles.cursorxz2 = line('Parent', handles.axesxz, 'Color', [.4 .8 1], 'LineStyle', ':', 'XLimInclude', 'off', 'YLimInclude', 'off');
set(handles.axesxz, 'YDir', 'normal', 'XDir', 'reverse', 'NextPlot', 'add', 'CLim', [-450 1050], 'CLimInclude', 'off');
handles.contourxz = 0;

% 3-D plot initialization
handles.cursor3dx = line('Parent', handles.axes3d, 'Color', [0 0 1], 'LineStyle', '--', 'XLimInclude', 'off', 'YLimInclude', 'off');
handles.cursor3dy = line('Parent', handles.axes3d, 'Color', [0 0 1], 'LineStyle', '--', 'XLimInclude', 'off', 'YLimInclude', 'off');
handles.cursor3dz = line('Parent', handles.axes3d, 'Color', [0 0 1], 'LineStyle', '--', 'XLimInclude', 'off', 'YLimInclude', 'off');
handles.patch3d = patch('FaceColor', [0 1 0], 'EdgeColor', 'none', 'Parent', handles.axes3d, ...
  'FaceLighting', 'gouraud', 'EdgeLighting', 'gouraud');
set(handles.axes3d, 'YDir', 'reverse');
view(handles.axes3d, 3);

% Choose default command line output for aamexplorer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes aamexplorer wait for user response (see UIRESUME)
% uiwait(handles.main);

param_Callback(hObject, eventdata, handles);
moveCursor(hObject);

lh = camlight('left');
set(lh, 'Color', [.5 .5 .5], 'Parent', handles.axes3d);
lh = camlight('right');
set(lh, 'Color', [.5 .5 .5], 'Parent', handles.axes3d);


% --- Outputs from this function are returned to the command line.
function varargout = aamexplorer_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when main is resized.
function main_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pos = get(hObject, 'Position');
width = pos(3);
height = pos(4);

pw = 180;
margin = [16 8 8 8];
panelw = fix((width-pw)/2);
panelh = fix(height/2);

set(handles.panelparam, 'Position', [1, 1, pw, height]);
set(handles.panelxy, 'Position', [pw,        panelh, panelw, panelh]);
set(handles.panelyz, 'Position', [pw+panelw, panelh, panelw, panelh]);
set(handles.panel3d, 'Position', [pw,        1,      panelw, panelh]);
set(handles.panelxz, 'Position', [pw+panelw, 1,      panelw, panelh]);
set(handles.axesxy, 'Position', [margin(4), margin(3), panelw-margin(2)-margin(4), panelh-margin(1)-margin(3)]);
set(handles.axesyz, 'Position', [margin(4), margin(3), panelw-margin(2)-margin(4), panelh-margin(1)-margin(3)]);
set(handles.axes3d, 'Position', [margin(4), margin(3), panelw-margin(2)-margin(4), panelh-margin(1)-margin(3)]);
set(handles.axesxz, 'Position', [margin(4), margin(3), panelw-margin(2)-margin(4), panelh-margin(1)-margin(3)]);
set(handles.buttonreset,   'Position', [8,  height-37, 78, 21]);
set(handles.buttoninitial, 'Position', [94, height-37, 78, 21]);
set(handles.param1, 'Position', [8, height-60 , 164, 15]);
set(handles.param2, 'Position', [8, height-83 , 164, 15]);
set(handles.param3, 'Position', [8, height-106, 164, 15]);
set(handles.param4, 'Position', [8, height-129, 164, 15]);
set(handles.param5, 'Position', [8, height-152, 164, 15]);


% --- Executes on parameter slider movement.
function param_Callback(hObject, eventdata, handles)
% hObject    handle to paramX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

c = zeros(length(handles.model.sigma2c),1);
c(1) = get(handles.param1, 'Value');
c(2) = get(handles.param2, 'Value');
c(3) = get(handles.param3, 'Value');
c(4) = get(handles.param4, 'Value');
c(5) = get(handles.param5, 'Value');
c = c .* 2 .* sqrt(handles.model.sigma2c);

handles.state.shape = reshape(handles.model.mshape + handles.model.Qshape * c, ...
  handles.model.dimensions);
handles.state.gray = reshape(handles.model.mgray + handles.model.Qgray * c, ...
  handles.model.dimensions);

guidata(hObject, handles);

plotxy(hObject);
plotyz(hObject);
plotxz(hObject);

% 3-D
plot3d(hObject);


function plotxy(hObject)
handles = guidata(hObject);

slice = round(handles.state.cursor(3));
shape = permute(squeeze(handles.state.shape(:,:,slice)), [2 1]);
gray = permute(squeeze(handles.state.gray(:,:,slice)), [2 1]);

set(handles.imagexy, 'CData', gray);
axis(handles.axesxy, 'off', 'equal');

if handles.contourxy
  delete(handles.contourxy);
  handles.contourxy = 0;
end
[~,handles.contourxy] = contour(handles.axesxy, shape, [0 0], 'g');

guidata(hObject, handles);


function plotyz(hObject)
handles = guidata(hObject);

slice = round(handles.state.cursor(1));
shape = permute(squeeze(handles.state.shape(slice,:,:)), [2 1]);
gray = permute(squeeze(handles.state.gray(slice,:,:)), [2 1]);

set(handles.imageyz, 'CData', gray);
axis(handles.axesyz, 'off', 'equal');

if handles.contouryz
  delete(handles.contouryz);
  handles.contouryz = 0;
end
[~,handles.contouryz] = contour(handles.axesyz, shape, [0 0], 'g');

guidata(hObject, handles);


function plotxz(hObject)
handles = guidata(hObject);

% X-Z
slice = round(handles.state.cursor(2));
shape = permute(squeeze(handles.state.shape(:,slice,:)), [2 1]);
gray = permute(squeeze(handles.state.gray(:,slice,:)), [2 1]);

set(handles.imagexz, 'CData', gray);
axis(handles.axesxz, 'off', 'equal');

if handles.contourxz
  delete(handles.contourxz);
  handles.contourxz = 0;
end
[~,handles.contourxz] = contour(handles.axesxz, shape, [0 0], 'g');

guidata(hObject, handles);


function plot3d(hObject)
handles = guidata(hObject);

[f,v] = isosurface(handles.state.shape, 0);
set(handles.patch3d, 'Faces', f, 'Vertices', v);
axis(handles.axes3d, 'off', 'equal', 'vis3d');
set(handles.axes3d, 'XLim', [min(v(:,1)) max(v(:,1))], ...
  'YLim', [min(v(:,2)) max(v(:,2))], ...
  'ZLim', [min(v(:,3)) max(v(:,3))]);

guidata(hObject, handles);


function moveCursor(hObject)
handles = guidata(hObject);

cursor = handles.state.cursor;
ax = handles.axes3d;
xlimit = get(ax, 'XLim');
ylimit = get(ax, 'YLim');
zlimit = get(ax, 'ZLim');
xlimit = [-100 2*xlimit(2)];
ylimit = [-100 2*ylimit(2)];
zlimit = [-100 2*zlimit(2)];

set(handles.cursor3dx, 'YData', [cursor(1) cursor(1)], ...
  'XData', [cursor(2) cursor(2)], 'ZData', zlimit);
set(handles.cursor3dy, 'YData', xlimit, ...
  'XData', [cursor(2) cursor(2)], 'ZData', [cursor(3) cursor(3)]);
set(handles.cursor3dz, 'YData', [cursor(1) cursor(1)], ...
  'XData', ylimit, 'ZData', [cursor(3) cursor(3)]);

set(handles.cursorxy1, 'XData', [cursor(1) cursor(1)], 'YData', get(handles.axesxy, 'YLim'));
set(handles.cursorxy2, 'XData', get(handles.axesxy, 'XLim'), 'YData', [cursor(2) cursor(2)]);

set(handles.cursoryz1, 'XData', [cursor(2) cursor(2)], 'YData', get(handles.axesyz, 'YLim'));
set(handles.cursoryz2, 'XData', get(handles.axesyz, 'XLim'), 'YData', [cursor(3) cursor(3)]);

set(handles.cursorxz1, 'XData', [cursor(1) cursor(1)], 'YData', get(handles.axesxz, 'YLim'));
set(handles.cursorxz2, 'XData', get(handles.axesxz, 'XLim'), 'YData', [cursor(3) cursor(3)]);

guidata(hObject, handles);


% --- Executes on button press in buttonreset.
function buttonreset_Callback(hObject, eventdata, handles)
% hObject    handle to buttonreset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.param1, 'Value', 0);
set(handles.param2, 'Value', 0);
set(handles.param3, 'Value', 0);
set(handles.param4, 'Value', 0);
set(handles.param5, 'Value', 0);
param_Callback(hObject, eventdata, handles);


% --- Executes on button press in buttoninitial.
function buttoninitial_Callback(hObject, eventdata, handles)
% hObject    handle to buttoninitial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

c = handles.model.c ./ sqrt(handles.model.sigma2c) ./ (-2);
set(handles.param1, 'Value', c(1));
set(handles.param2, 'Value', c(2));
set(handles.param3, 'Value', c(3));
set(handles.param4, 'Value', c(4));
set(handles.param5, 'Value', c(5));
param_Callback(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function param1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to param1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
  set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function param2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to param2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
  set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function param3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to param3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
  set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function param4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to param4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
  set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function param5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to param5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
  set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on scroll wheel click while the figure is in focus.
function main_WindowScrollWheelFcn(hObject, eventdata, handles)
% hObject    handle to main (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	VerticalScrollCount: signed integer indicating direction and number of clicks
%	VerticalScrollAmount: number of lines scrolled for each click
% handles    structure with handles and user data (see GUIDATA)

pointer = get(hObject, 'CurrentPoint');

xypanelpos = get(handles.panelxy, 'Position');
xypos = get(handles.axesxy, 'Position');
xypos(1:2) = xypanelpos(1:2) + xypos(1:2);

yzpanelpos = get(handles.panelyz, 'Position');
yzpos = get(handles.axesyz, 'Position');
yzpos(1:2) = yzpanelpos(1:2) + yzpos(1:2);

xzpanelpos = get(handles.panelxz, 'Position');
xzpos = get(handles.axesxz, 'Position');
xzpos(1:2) = xzpanelpos(1:2) + xzpos(1:2);

% Within X-Y figure
if pointer(1) > xypos(1) && pointer(1) < xypos(1) + xypos(3) && ...
    pointer(2) > xypos(2) && pointer(2) < xypos(2) + xypos(4)
  z = handles.state.cursor(3) - eventdata.VerticalScrollCount;
  handles.state.cursor(3) = max(min(z, handles.model.dimensions(3)), 1);
  guidata(hObject, handles);
  plotxy(hObject);
  
  % Within Y-Z figure
elseif pointer(1) > yzpos(1) && pointer(1) < yzpos(1) + yzpos(3) && ...
    pointer(2) > yzpos(2) && pointer(2) < yzpos(2) + yzpos(4)
  x = handles.state.cursor(1) + eventdata.VerticalScrollCount;
  handles.state.cursor(1) = max(min(x, handles.model.dimensions(1)), 1);
  guidata(hObject, handles);
  plotyz(hObject);
  
  % Within X-Z figure
elseif pointer(1) > xzpos(1) && pointer(1) < xzpos(1) + xzpos(3) && ...
    pointer(2) > xzpos(2) && pointer(2) < xzpos(2) + xzpos(4)
  y = handles.state.cursor(2) + eventdata.VerticalScrollCount;
  handles.state.cursor(2) = max(min(y, handles.model.dimensions(2)), 1);
  guidata(hObject, handles);
  plotxz(hObject);
end

moveCursor(hObject);


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function main_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pointer = get(hObject, 'CurrentPoint');

xypanelpos = get(handles.panelxy, 'Position');
xypos = get(handles.axesxy, 'Position');
xypos(1:2) = xypanelpos(1:2) + xypos(1:2);

yzpanelpos = get(handles.panelyz, 'Position');
yzpos = get(handles.axesyz, 'Position');
yzpos(1:2) = yzpanelpos(1:2) + yzpos(1:2);

xzpanelpos = get(handles.panelxz, 'Position');
xzpos = get(handles.axesxz, 'Position');
xzpos(1:2) = xzpanelpos(1:2) + xzpos(1:2);

dim = handles.model.dimensions;

% Within X-Y figure
if pointer(1) > xypos(1) && pointer(1) < xypos(1) + xypos(3) && ...
    pointer(2) > xypos(2) && pointer(2) < xypos(2) + xypos(4)
  coord = get(handles.axesxy, 'CurrentPoint');
  if coord(1,1) > 0 && coord(1,1) < dim(1) && coord(1,2) > 0 && coord(1,2) < dim(2)
    handles.state.cursor(1) = coord(1,1);
    handles.state.cursor(2) = coord(1,2);
    guidata(hObject, handles);
    plotyz(hObject);
    plotxz(hObject);
  end
  
  % Within Y-Z figure
elseif pointer(1) > yzpos(1) && pointer(1) < yzpos(1) + yzpos(3) && ...
    pointer(2) > yzpos(2) && pointer(2) < yzpos(2) + yzpos(4)
  coord = get(handles.axesyz, 'CurrentPoint');
  if coord(1,1) > 0 && coord(1,1) < dim(2) && coord(1,2) > 0 && coord(1,2) < dim(3)
    handles.state.cursor(2) = coord(1,1);
    handles.state.cursor(3) = coord(1,2);
    guidata(hObject, handles);
    plotxy(hObject);
    plotxz(hObject);
  end
  
  % Within X-Z figure
elseif pointer(1) > xzpos(1) && pointer(1) < xzpos(1) + xzpos(3) && ...
    pointer(2) > xzpos(2) && pointer(2) < xzpos(2) + xzpos(4)
  coord = get(handles.axesxz, 'CurrentPoint');
  if coord(1,1) > 0 && coord(1,1) < dim(1) && coord(1,2) > 0 && coord(1,2) < dim(3)
    handles.state.cursor(1) = coord(1,1);
    handles.state.cursor(3) = coord(1,2);
    guidata(hObject, handles);
    plotxy(hObject);
    plotyz(hObject);
  end
end

moveCursor(hObject);
