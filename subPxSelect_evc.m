function [out1, out2] = subPxSelect_evc(c0, c1, c2) % c0:元画像の色 c1, c2:各シートに当てる画像の色
    spp_50 = cat(3,[0 0; 1 1],[1 1; 0 0], [0 1; 0 1], ...
        [1 0; 1 0], [0 1; 1 0], [1 0; 0 1]);
    spp_75 = cat(3, [0 0; 0 1], [0 0; 1 0], [0 1; 0 0], [1 0; 0 0]);
    
    n = randi(6); % spp_50用
    m = randi(4); % spp_75用
    r2 = randi(2); r3 = randi(3); r4 = randi(4); % ピクセル選択に用いる乱数

    if c1 == 'w'
        out1 = spp_50(:,:,n); % c1 == 'w'の場合に一方のシートに割り当てるサブピクセル 
    else
        out1 = spp_75(:,:,m); % c1 == 'b'の場合に一方のシートに割り当てるサブピクセル 
    end

    if c0 == 'w' && c1 == 'w' && c2 == 'w'
        if n == 1 || n == 2
            choice = cat(3, spp_50(:,:,3), spp_50(:,:,4), spp_50(:,:,5), spp_50(:,:,6)); % 条件を満たすピクセルを列挙
            out2 = choice(:,:,r4); % ランダムに選択
        
        elseif n == 3 || n == 4
            choice = cat(3, spp_50(:,:,1), spp_50(:,:,2), spp_50(:,:,5), spp_50(:,:,6));
            out2 = choice(:,:,r4);
        
        else
            choice = cat(3, spp_50(:,:,1), spp_50(:,:,2), spp_50(:,:,3), spp_50(:,:,4));
            out2 = choice(:,:,r4);
        end
    elseif  c0 == 'w' && c1 == 'w' && c2 == 'b'
        if n == 1
            choice = cat(3, spp_75(:,:,1), spp_75(:,:,2));
            out2 = choice(:,:,r2);
        
        elseif n == 2
            choice = cat(3, spp_75(:,:,3), spp_75(:,:,4));
            out2 = choice(:,:,r2);
        
        elseif n == 3
            choice = cat(3, spp_75(:,:,1), spp_75(:,:,3));
            out2 = choice(:,:,r2);
        
        elseif n == 4
            choice = cat(3, spp_75(:,:,2), spp_75(:,:,4));
            out2 = choice(:,:,r2);
        
        elseif n == 5
            choice = cat(3, spp_75(:,:,2), spp_75(:,:,3));
            out2 = choice(:,:,r2);
        
        else
            choice = cat(3, spp_75(:,:,1), spp_75(:,:,4));
            out2 = choice(:,:,r2);
        end
    elseif c0 == 'w' && c1 == 'b' && c2 == 'w'
        if m == 1
            choice = cat(3, spp_50(:,:,1), spp_50(:,:,3), spp_50(:,:,6));
            out2 = choice(:,:,r3);
        
        elseif m == 2
            choice = cat(3, spp_50(:,:,1), spp_50(:,:,4), spp_50(:,:,5));
            out2 = choice(:,:,r3);
        
        elseif m == 3
            choice = cat(3, spp_50(:,:,2), spp_50(:,:,3), spp_50(:,:,5));
            out2 = choice(:,:,r3);
        
        else
            choice = cat(3, spp_50(:,:,2), spp_50(:,:,4), spp_50(:,:,6));
            out2 = choice(:,:,r3);
        end
    elseif c0 == 'w' && c1 == 'b' && c2 == 'b'
        out2 = spp_75(:,:,m);
    elseif c0 == 'b' && c1 == 'w' && c2 == 'w'
        out2 = ~out1;
    elseif c0 == 'b' && c1 == 'w' && c2 == 'b'
        if n == 1
            choice = cat(3, spp_75(:,:,3), spp_75(:,:,4));
            out2 = choice(:,:,r2);
    
        elseif n == 2
            choice = cat(3, spp_75(:,:,1), spp_75(:,:,2));
            out2 = choice(:,:,r2);

        elseif n == 3
            choice = cat(3, spp_75(:,:,2), spp_75(:,:,4));
            out2 = choice(:,:,r2);

        elseif n == 4
            choice = cat(3, spp_75(:,:,1), spp_75(:,:,3));
            out2 = choice(:,:,r2);

        elseif n == 5
            choice = cat(3, spp_75(:,:,1), spp_75(:,:,4));
            out2 = choice(:,:,r2);

        else
            choice = cat(3, spp_75(:,:,2), spp_75(:,:,3));
            out2 = choice(:,:,r2);
        end

    elseif c0 == 'b' && c1 == 'b' && c2 == 'w'
        if m == 1
            choice = cat(3, spp_50(:,:,2), spp_50(:,:,4), spp_50(:,:,5));
            out2 = choice(:,:,r3);

        elseif m == 2
            choice = cat(3, spp_50(:,:,2), spp_50(:,:,3), spp_50(:,:,6));
            out2 = choice(:,:,r3);

        elseif m == 3
            choice = cat(3, spp_50(:,:,1), spp_50(:,:,4), spp_50(:,:,6));
            out2 = choice(:,:,r3);

        else
            choice = cat(3, spp_50(:,:,1), spp_50(:,:,3), spp_50(:,:,5));
            out2 = choice(:,:,r3);
        end

    elseif c0 == 'b' && c1 == 'b' && c2 == 'b'
        if m == 1
            choice = cat(3, spp_75(:,:,2), spp_75(:,:,3), spp_75(:,:,4));
            out2 = choice(:,:,r3);

        elseif m == 2
            choice = cat(3, spp_75(:,:,1), spp_75(:,:,3), spp_75(:,:,4));
            out2 = choice(:,:,r3);

        elseif m == 3
            choice = cat(3, spp_75(:,:,1), spp_75(:,:,2), spp_75(:,:,4));
            out2 = choice(:,:,r3);

        else
            choice = cat(3, spp_75(:,:,1), spp_75(:,:,2), spp_75(:,:,3));
            out2 = choice(:,:,r3);
        end
    end
end