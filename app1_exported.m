classdef app1_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure          matlab.ui.Figure
        EVCEncryptionBtn  matlab.ui.control.Button
        DecryptionBtn     matlab.ui.control.Button
        EncryptionBtn     matlab.ui.control.Button
        Slider            matlab.ui.control.Slider
        Label             matlab.ui.control.Label
        DeleteBtn         matlab.ui.control.Button
        SaveBtn           matlab.ui.control.Button
        LineColorBtn      matlab.ui.control.Button
        UIAxes            matlab.ui.control.UIAxes
    end

    
    properties (Access = private)
         % プロパティの設定

         buttonState = false; % マウスボタンが押されているかどうか
         curLineH = gobjects; % Lineのオブジェクト
         curLineX = []; % LineのX座標 
         curLineY = []; % LineのY座標
         LineColor = [0,0,0]; % Lineの色
         LineWidth = 1; % Lineの太さ
    end


    % Callbacks that handle component events
    methods (Access = private)

        % Window button down function: UIFigure
        function UIFigureWindowButtonDown(app, ~)
            app.buttonState = true; % マウスボタン押下

            % マウス座標の取得
            app.curLineX = app.UIAxes.CurrentPoint(1,1);
            app.curLineY = app.UIAxes.CurrentPoint(1,2);

            % 線の描画
            app.curLineH = line(app.UIAxes,app.curLineX,app.curLineY, ...
                           'Color',app.LineColor,'LineWidth',app.LineWidth);
        end

        % Window button up function: UIFigure
        function UIFigureWindowButtonUp(app, ~)
            app.buttonState = false; % マウスボタン解放
        end

        % Window button motion function: UIFigure
        function UIFigureWindowButtonMotion(app, ~)
            if app.buttonState % マウスボタンが押下されている時には，Lineの描画を更新
                
                % 現在のマウスの座標
                X = app.UIAxes.CurrentPoint(1,1);
                Y = app.UIAxes.CurrentPoint(1,2);

                % 線の座標を更新
                app.curLineX = [app.curLineX;X];
                app.curLineY = [app.curLineY;Y];

                % 描画の更新
                app.curLineH.XData = app.curLineX;
                app.curLineH.YData = app.curLineY;
            end
        end

        % Button pushed function: LineColorBtn
        function LineColorBtnPushed(app, ~)
            % 色の変更ボタンのコールバック
            
            % ダイアログuisetcolorを用いて色を指定
            c = uisetcolor(app.LineColor);
            if length(c) == 3
                app.LineColor = c;
            end
        end

        % Button pushed function: SaveBtn
        function SaveBtnPushed(app, ~)
            % 保存ボタンのコールバック
            
            filter = {'*.png';'*.jpg';'*.tif';'*.pdf';'*.eps';'*.bmp'}; % 対応する保存形式
            [file,path] = uiputfile(filter); % filterに記述した形式のいずれかで保存，ファイル名を指定
            if ischar(file)
                exportgraphics(app.UIAxes,[path,file]);
                msg = '保存した画像を暗号化しますか？';
                title = '暗号化';
                selection = uiconfirm(app.UIFigure,msg,title, ...
                           'Options',{'はい','いいえ'}, ...
                           'DefaultOption',1,'CancelOption',2);
                if selection == "はい"
                    encryption(fullfile(path,file));
                end
            end
        end

        % Button pushed function: DeleteBtn
        function DeleteBtnPushed(app, ~)
            % 消去ボタンのコールバック
            
            delete(findobj(app.UIAxes,'Type','Line'));
        end

        % Value changed function: Slider
        function SliderValueChanged(app, ~)
            % 線の太さ変更スライダーのコールバック
            
            value = app.Slider.Value; % スライダーの値を取得

            % 値を四捨五入し，スライダーの位置とLineWidthに反映
            value = round(value);
            app.Slider.Value = value;
            app.LineWidth = value;
        end

        % Button pushed function: EncryptionBtn
        function EncryptionBtnPushed(app, ~)
            % 暗号化ボタンのコールバック
            
            msg = '暗号化する画像を選択してください．';
            selection = uiconfirm(app.UIFigure,msg,'', ...
                       'Options',{'了解しました'}, ...
                       'DefaultOption',1);
            if selection == "了解しました"
                [file,path] = uigetfile({'*.*','すべてのファイル (*.*)'},...
                              '暗号化する画像を選択','MultiSelect','on');
                if ~isequal(file,0)
                   encryption(fullfile(path,file));
                end
            end
        end

        % Button pushed function: DecryptionBtn
        function DecryptionBtnPushed(app, ~)
            % 復号ボタンのコールバック
            
            msg = '復号する2つの画像を選択してください．';
            selection = uiconfirm(app.UIFigure,msg,'', ...
                       'Options',{'了解しました'}, ...
                       'DefaultOption',1);
            if selection == "了解しました"
                [file,path] = uigetfile({'*.*','すべてのファイル (*.*)'},...
                            '復号する2つの画像を選択','MultiSelect','on');
                if ~isequal(file,0)
                   decryption(fullfile(path,file{1}), fullfile(path,file{2}));
                end
            end
        end

        % Button pushed function: EVCEncryptionBtn
        function EVCEncryptionBtnPushed(app, ~)
            % 暗号化(拡張)ボタンのコールバック

            msg = '暗号化する暗号を選択してください．';
            selection = uiconfirm(app.UIFigure,msg,'', ...
                       'Options',{'了解しました'}, ...
                       'DefaultOption',1);
            if selection == "了解しました"
                [file,path] = uigetfile({'*.*','すべてのファイル (*.*)'},'暗号化する画像を選択');
                if ~isequal(file,0)
                    fullfile1 = fullfile(path,file);
                end
            end
            
            if exist('fullfile1','var')
                msg = 'シートに表示する2つの画像を選択してください．';
                selection = uiconfirm(app.UIFigure,msg,'', ...
                           'Options',{'了解しました'}, ...
                           'DefaultOption',1);
                if selection == "了解しました"
                    [file,path] = uigetfile({'*.*','すべてのファイル (*.*)'},...
                                  'シートに表示する2つの画像を選択','MultiSelect','on');
                    if ~isequal(file,0)
                        fullfile2 = fullfile(path,file{1});
                        fullfile3 = fullfile(path,file{2});
                    end
                end
            end

            if exist('fullfile1','var') && exist('fullfile2','var') && exist('fullfile3','var')
                encryption_evc(fullfile1, fullfile2, fullfile3);
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 570];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.WindowButtonDownFcn = createCallbackFcn(app, @UIFigureWindowButtonDown, true);
            app.UIFigure.WindowButtonUpFcn = createCallbackFcn(app, @UIFigureWindowButtonUp, true);
            app.UIFigure.WindowButtonMotionFcn = createCallbackFcn(app, @UIFigureWindowButtonMotion, true);

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            app.UIAxes.XLim = [0 1];
            app.UIAxes.YLim = [0 1];
            app.UIAxes.ZLim = [0 1];
            app.UIAxes.XColor = 'none';
            app.UIAxes.XTick = [];
            app.UIAxes.YColor = 'none';
            app.UIAxes.YTick = [];
            app.UIAxes.ZTick = [];
            app.UIAxes.FontUnits = 'normalized';
            app.UIAxes.Position = [2 91 640 480];

            % Create LineColorBtn
            app.LineColorBtn = uibutton(app.UIFigure, 'push');
            app.LineColorBtn.ButtonPushedFcn = createCallbackFcn(app, @LineColorBtnPushed, true);
            app.LineColorBtn.Position = [25 68 115 23];
            app.LineColorBtn.Text = '色の変更';

            % Create SaveBtn
            app.SaveBtn = uibutton(app.UIFigure, 'push');
            app.SaveBtn.ButtonPushedFcn = createCallbackFcn(app, @SaveBtnPushed, true);
            app.SaveBtn.Position = [140 68 115 23];
            app.SaveBtn.Text = '絵の保存・暗号化';

            % Create DeleteBtn
            app.DeleteBtn = uibutton(app.UIFigure, 'push');
            app.DeleteBtn.ButtonPushedFcn = createCallbackFcn(app, @DeleteBtnPushed, true);
            app.DeleteBtn.Position = [255 68 100 23];
            app.DeleteBtn.Text = '消去';

            % Create Label
            app.Label = uilabel(app.UIFigure);
            app.Label.HorizontalAlignment = 'right';
            app.Label.Position = [357 61 53 22];
            app.Label.Text = '線の太さ';

            % Create Slider
            app.Slider = uislider(app.UIFigure);
            app.Slider.Limits = [1 5];
            app.Slider.MajorTicks = [1 2 3 4 5];
            app.Slider.MajorTickLabels = {'細', '', '', '', '太'};
            app.Slider.ValueChangedFcn = createCallbackFcn(app, @SliderValueChanged, true);
            app.Slider.MinorTicks = [];
            app.Slider.Position = [429 71 150 3];
            app.Slider.Value = 1;

            % Create EncryptionBtn
            app.EncryptionBtn = uibutton(app.UIFigure, 'push');
            app.EncryptionBtn.ButtonPushedFcn = createCallbackFcn(app, @EncryptionBtnPushed, true);
            app.EncryptionBtn.Position = [25 29 115 23];
            app.EncryptionBtn.Text = '画像の暗号化';

            % Create DecryptionBtn
            app.DecryptionBtn = uibutton(app.UIFigure, 'push');
            app.DecryptionBtn.ButtonPushedFcn = createCallbackFcn(app, @DecryptionBtnPushed, true);
            app.DecryptionBtn.Position = [255 29 100 23];
            app.DecryptionBtn.Text = '復号';

            % Create EVCEncryptionBtn
            app.EVCEncryptionBtn = uibutton(app.UIFigure, 'push');
            app.EVCEncryptionBtn.ButtonPushedFcn = createCallbackFcn(app, @EVCEncryptionBtnPushed, true);
            app.EVCEncryptionBtn.Position = [140 29 115 23];
            app.EVCEncryptionBtn.Text = '画像の暗号化(拡張)';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = app1_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end