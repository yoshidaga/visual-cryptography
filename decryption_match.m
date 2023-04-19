function decryption_match(image1, image2)
    A = imread(image1); A = imbinarize(A(:,:,1)); % 画像を読み込み，バイナリ化
    B = imread(image2); B = imbinarize(B(:,:,1));
    Aheight = size(A,1);
    Bheight = size(B,1);
    A1 = reshape(A, Aheight, [], 2);
    B1 = reshape(B, Bheight, [], 2);
    C = imfuse(A1(:,:,1), B1(:,:,2), 'blend', 'Scaling', 'joint'); % 潜性復号に必要な領域のみを重ね合わせ
    D = C > 128;
    E = imtile({B1(:,:,1), D, A1(:,:,2)}, 'GridSize', [1 3]); % 残りの領域を結合し，実際に重ね合わせたかのように見せる
    imshow(E(:,:,1));
    imsave;
end