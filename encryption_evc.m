function encryption_evc(image0, image1, image2) % image0:暗号化する画像 image1, image2:シート作成に用いる画像
    % 各画像をRGB値による行列として取得
    originalImage = imread(image0); 
    seatImage1 = imread(image1);
    seatImage2 = imread(image2);

    [originalImageWidth, originalImageHeight] = size(originalImage,[1 2]); % 画像の幅と高さを取得

    % シートの画像サイズをoriginalImageに合わせる
    seatImage1 = imresize(seatImage1,[originalImageWidth, originalImageHeight]);
    seatImage2 = imresize(seatImage2,[originalImageWidth, originalImageHeight]);

    % 画像の幅と高さを2倍にして，暗号化した画像の幅と高さとして設定
    encImageWidth = originalImageWidth*2; 
    encImageHeight = originalImageHeight*2;

    % encImageWidth, encImageHeightを用いてシートのRGB値を保存する配列を生成
    seat1 = zeros(encImageWidth, encImageHeight);
    seat2 = zeros(encImageWidth, encImageHeight);
    
    for i = 1:2:encImageWidth
        for j = 1:2:encImageHeight
            % 各画像のピクセルを取得し，割り当てるサブピクセルを決定
            if mean(originalImage((i+1)/2, (j+1)/2, :)) >= 128
                if mean(seatImage1((i+1)/2, (j+1)/2, :)) >= 128
                    if mean(seatImage2((i+1)/2, (j+1)/2, :)) >= 128
                        [pixel1, pixel2] = subPxSelect_evc('w','w','w');
                    else
                        [pixel1, pixel2] = subPxSelect_evc('w','w','b');
                    end
                else
                    if mean(seatImage2((i+1)/2, (j+1)/2, :)) >= 128
                        [pixel1, pixel2] = subPxSelect_evc('w','b','w');
                    else
                        [pixel1, pixel2] = subPxSelect_evc('w','b','b');
                    end
                end
            else
                if mean(seatImage1((i+1)/2, (j+1)/2, :)) >= 128
                    if mean(seatImage2((i+1)/2, (j+1)/2, :)) >= 128
                        [pixel1, pixel2] = subPxSelect_evc('b','w','w');
                    else
                        [pixel1, pixel2] = subPxSelect_evc('b','w','b');
                    end
                else
                    if mean(seatImage2((i+1)/2, (j+1)/2, :)) >= 128
                        [pixel1, pixel2] = subPxSelect_evc('b','b','w');
                    else
                        [pixel1, pixel2] = subPxSelect_evc('b','b','b');
                    end
                end
            end
            % シートに割り当て
            seat1(i:i+1, j:j+1) = pixel1;
            seat2(i:i+1, j:j+1) = pixel2;
        end
    end

    % 配列を画像に変換し，保存
    imshow(seat1);
    imsave;
    imshow(seat2);
    imsave;
end