function encryption_match(image, seat1, seat2)

    [seatHeight, seatWidth] = size(imread(seat1), [1 2]); % シートのサイズを取得
    originalImage_fit = imresize(imread(image), [seatHeight/2, seatWidth]); % 画像をシートのサイズに合うように変更
    originalImage_bin = imbinarize(originalImage_fit); % 画像をバイナリ化(logical値を持つ行列に変換される)
    originalImage = originalImage_bin(:,:,1);
    [originalImageHeight, originalImageWidth] = size(originalImage,[1 2]); % 画像の幅と高さを取得

    originalImage = reshape(originalImage, originalImageHeight, [], 2); % 画像(行列)を半分に分割
    
    encImageHeight = originalImageHeight*2;
    encImageWidth = originalImageWidth;

    seat1 = imbinarize(imread(seat1));
    seat2 = imbinarize(imread(seat2));

    % シートをコピーする．必要に応じてピクセルを変更．
    matchSeat1 = seat2(:,:,1);
    matchSeat2 = seat1(:,:,1);
    
    for i = 1:2:encImageHeight
        for j = 1:2:encImageWidth
            if originalImage((i+1)/2, (j+1)/2, 1) == 0
                % S_bとなるサブピクセルを割り当て
                matchSeat2(i:i+1, j:j+1) = ~seat1(i:i+1, j:j+1);
            end
            if originalImage((i+1)/2, (j+1)/2, 2) == 0
                % S_bとなるサブピクセルを割り当て
                matchSeat1(i:i+1, j:j+1) = ~seat2(i:i+1, j:j+1);
            end
        end
    end

    out1 = imtile({seat1, matchSeat1});
    out2 = imtile({matchSeat2, seat2});

    % 配列を画像に変換し，保存
    imshow(out1);
    imsave;
    imshow(out2);
    imsave;
end