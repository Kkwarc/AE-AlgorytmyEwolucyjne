function [xsol,fval,history, info] = runfmincon(mainAlgorytm, inAlgorytm, Gradient, Hesian, initPoint, const, i)
 
% Set up shared variables with outfun
history.x = [];
history.fval = [];
 
% Call optimization
x0 = [initPoint(1), initPoint(2)];
a = const(1);
b = const(2);

grad = true;
if strcmp(Gradient, 'None')
    grad = false;
end

if strcmp(mainAlgorytm, 'fminunc')
    if grad == true
        opts = optimoptions('fminunc','Algorithm', inAlgorytm, ...
        'Display','iter','SpecifyObjectiveGradient', true, 'TolFun', 1e-10, 'OutputFcn',@outfun);
        [xsol,fval, f, info] = fminunc(@(x) fbanan(x, a, b), [x0(1), x0(2)], opts);
        logPlot(history)
        
    else
        opts = optimoptions('fminunc','Algorithm', inAlgorytm, ...
        'Display','iter','GradObj', 'on', 'TolFun', 1e-10, 'OutputFcn',@outfun);
        [xsol,fval, f, info] = fminunc(@(x) fbanan(x, a, b), [x0(1), x0(2)], opts);
        logPlot(history)
        
    end
elseif strcmp(mainAlgorytm, 'fminsearch')
     opts = optimset('Display','iter',...
         'TolFun', 1e-10, 'OutputFcn',@outfun);
    [xsol,fval, f, info] = fminsearch(@(x) fbanan(x, a, b), [x0(1), x0(2)], opts);
    logPlot(history)
    
end
    
 function stop = outfun(x,optimValues,state)
     stop = false;
     hold on
     switch state
         case 'iter'
         % Concatenate current point and objective function
         % value with history. x must be a row vector.
           history.fval = [history.fval; optimValues.fval];
           history.x = [history.x; x];

           figure(2*i-1)
           plot(x(1),x(2),'o');
           
           %after second iteration start arrows
           if size(history.x)>=2
               one=history.x(end,:);
               two=history.x(end-1,:);
               diff = one-two;
               quiver(two(1),two(2),diff(1),diff(2),0,'color',[0 0 1])
           end
           if strcmp(inAlgorytm, 'None')
                var = '';
            else
                var = [', ', inAlgorytm];
            end
           if grad
               text = ['Algorytm: ', mainAlgorytm, var, ', ', 'GradSupp', ', ', ...
                   ' Start point: ', num2str(x0(1)), ', ', num2str(x0(2))];
           else
               text = ['Algorytm: ', mainAlgorytm, var, ' Start point: ',...
                   num2str(x0(1)), ', ', num2str(x0(2))];
           end
           title(text);
         case 'done'
             hold off
             if grad
                 text = [mainAlgorytm, '_', inAlgorytm, ',', 'Grad', ',',...
                     'Start point_', num2str(x0(1)), '_', num2str(x0(2)), '.png'];
             else
                 text = [mainAlgorytm, '_', inAlgorytm, 'Start point_', num2str(x0(1)), ...
                     '_', num2str(x0(2)), '.png'];
             end
             print('-dpng', text, '-r400')
         otherwise
     end
 end
    function stop = logPlot(history)
        stop = false;
        figure(2*i)
        loglog((1:1:length(history.fval)) , history.fval)
        if strcmp(inAlgorytm, 'None')
            var = '';
        else
            var = [', ', inAlgorytm];
        end
        if grad
           text = ['Algorytm: ', mainAlgorytm, var ', ', 'GradSupp', ', ', ...
               ' Start point: ', num2str(x0(1)), ',', num2str(x0(2))];
       else
           text = ['Algorytm: ', mainAlgorytm, var, ' Start point: ',...
               num2str(x0(1)), ',', num2str(x0(2))];
       end
        title(text)
        if grad
            text = ['LOG', mainAlgorytm, '_', inAlgorytm, '_', 'GRAD', ...
                'Start point_', num2str(x0(1)), '_', num2str(x0(2)), '.png'];
        else
            text = ['LOG', mainAlgorytm, '_', inAlgorytm, 'Start point_', num2str(x0(1)), ...
                     '_', num2str(x0(2)), '.png'];
        end
        print('-dpng', text, '-r400')
    end
end