function [ ptemphist, jsdist ] = PEHypthosis( I, range, titlestr)
    [M,N] = size(I);
    

    errOne = zeros((M-3)*(N-3) , 1);


    k = 0;
    for i = 2:(M-2)
        for j = 2:(N-2)
            if mod(i+j,2) == 0
                k = k +1;
                pre =round( mean([I(i+1,j),I(i,j+1),I(i-1,j),I(i,j-1)]) );

                e1= (I(i,j) - pre); 
                errOne(k) = e1;

            end
        end
    end

    errOne = errOne(1:k);

    
    ptemphist = histc(errOne, range);    % condtional probability: P(E1=e1| E2= e2)
    %plot(range,ptemphist/sum(ptemphist),'-o');

    % === lap model ===
    errOne(errOne>range(end) | errOne<range(1)) = [];
    b = mean(abs(errOne));
    % t_area = sum(exp(-abs(-25:1:25)./b)./(2*b));
    fval = exp(-abs(range)./b)./(2*b);

    % === gau model ===
%     errOne(errOne>range(end) | errOne<range(1)) = [];
%     b = mean(abs(errOne).^2);
%     fval = exp(-(range).^2/(2*b))./(sqrt(2*pi*b));
    
    
    figure;
    plot(range,ptemphist/sum(ptemphist),'-s','MarkerSize',6,...
        'MarkerEdgeColor','blue','MarkerFaceColor','blue','linewidth',1.7);
    hold on;plot(range,fval/sum(fval),'-o','MarkerSize',3,...
        'MarkerEdgeColor','red','MarkerFaceColor','red','linewidth',1.3);
    xlabel('Prediction Error'); ylabel('Frequency');
    legend('Real Data','Hypothesis')
    set(gca,'FontSize', 13,'XTick',-20:4:19);
    set(findobj(gca,'Type','text'),'FontSize',13,'FontWeight','bold','VerticalAlignment','top'); 
    grid on;
    title(titlestr);
    jsdist=jsdiv(ptemphist/sum(ptemphist),fval'/sum(fval));
end

