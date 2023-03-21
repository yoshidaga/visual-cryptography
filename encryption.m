function encryption(image)
    originalImage = imread(image); % 画像をRGB値による行列として取得
    [originalImageWidth, originalImageHeight] = size(originalImage,[1 2]); % 画像の幅と高さを取得

    % 画像の幅と高さを2倍にして，暗号化した画像の幅と高さとして設定
    encImageWidth = originalImageWidth*2; 
    encImageHeight = originalImageHeight*2;

    % encImageWidth, encImageHeightを用いてシートのRGB値を保存する配列を生成
    seat1 = zeros(encImageWidth, encImageHeight);
    seat2 = zeros(encImageWidth, encImageHeight);
    
    for i = 1:2:encImageWidth
        for j = 1:2:encImageHeight
            % 秘密画像のピクセルを取得し，割り当てるサブピクセルを決定
            if mean(originalImage((i+1)/2, (j+1)/2, :)) >= 128
                % S_wとなるサブピクセルを生成
                [pixel1, pixel2] = subPxSelect('w');
            else
                % S_bとなるサブピクセルを生成
                [pixel1, pixel2] = subPxSelect('b');
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