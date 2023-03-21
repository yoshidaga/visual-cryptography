function [out1, out2] = subPxSelect(color)
    subPxPattern = cat(3,[0 0; 1 1],[1 1; 0 0], [0 1; 0 1], ...
        [1 0; 1 0], [0 1; 1 0], [1 0; 0 1]); % 2×2のサブピクセル全パターン
    n = randi(6); % 1~6の範囲の整数を取る一様乱数
    if color == 'b'

        % 乱数を用いて，S_bに対応するサブピクセルをランダムに取得
        out1 = subPxPattern(:,:,n);
        out2 = ~out1;

    elseif color == 'w'
        
        % 乱数を用いて，S_wに対応するサブピクセルをランダムに取得
        out1 = subPxPattern(:,:,n);
        out2 = subPxPattern(:,:,n);
    else
        disp('subPxSelect error');
    end
end