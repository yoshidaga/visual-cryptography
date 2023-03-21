function decryption(image1, image2)
    A = imread(image1);
    B = imread(image2);
    C = imfuse(A, B, 'blend', 'Scaling', 'joint');
    D = C > 128;
    imshow(D(:,:,1));
    imsave;
end