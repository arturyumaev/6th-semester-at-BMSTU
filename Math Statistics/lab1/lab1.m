function lab1
    clear
    X=[-17.04,-18.29,-17.38,-18.11,-18.96,-17.65,-17.02,-17.22,-16.25,-17.44,-17.69,-17.61,-17.09,-17.19,-16.02,-17.56,-16.94,-17.29,-16.93,-16.61,-19.38,-17.53,-16.39,-17.89,-17.98,-17.04,-16.22,-19.09,-18.91,-17.77,-18.30,-17.44,-18.84,-16.39,-16.13,-18.37,-16.37,-16.70,-17.78,-17.03,-17.76,-17.87,-17.20,-18.44,-17.19,-17.75,-16.81,-17.97,-18.03,-16.87,-16.10,-19.16,-16.51,-18.39,-16.48,-18.08,-17.49,-18.89,-19.09,-17.96,-18.40,-16.96,-18.15,-18.71,-17.81,-17.86,-19.47,-17.86,-17.60,-17.30,-17.60,-17.71,-18.42,-16.88,-16.76,-18.00,-17.97,-16.83,-18.00,-18.08,-17.61,-17.02,-16.73,-17.64,-18.76,-17.68,-18.04,-16.45,-18.79,-18.03,-17.38,-15.27,-15.97,-17.41,-18.61,-18.00,-17.42,-17.77,-19.05,-16.16,-16.27,-18.00,-18.90,-17.05,-17.46,-17.49,-18.20,-17.59,-15.78,-18.88,-18.53,-17.39,-17.83,-18.17,-16.15,-17.66,-17.76,-18.32,-17.70,-17.56];
    
    % Пункт a)
    Mmax = max(X);
    Mmin = min(X);
    
    % Пункт б)
    R = Mmax - Mmin;
    
    % Пункт в)
    mu = find_mu(X);
    S2 = find_S2(X);
    
    % Пункт г)
    % Гистограмма
    m = find_m(X);
    [J, count] = intervalization(X, m);
    stairs([J(1) J], [0 count 0]);
    % График 1
    hold on;
    Y1 = f(X, mu, S2);
    plot(X, Y1, '.');
    grid on;
    legend('Гистограмма','Функция плотности распределения нормальной СВ');
    hold off;
    % График 2
    figure;
    empF(sort(X));
    hold on;
    F(sort(X), mu, getS(X), m, R);
    grid on;
    legend('Эмпирическая функция распределения','Функция распределения нормальной СВ');
    hold off;

    function [mu] = find_mu(X)
        mu = sum(X)/size(X,2);
    end

    function [S2] = find_S2(X)
        S2 = sum((X - find_mu(X)) .* (X - find_mu(X)))/ (size(X,2) - 1);
    end

    function sigma = getSigmaSqr(X)
        tempMu = find_mu(X);
        sigma = sum((X - tempMu) .* (X - tempMu)) / size(X,2);
    end

    function Ssqr = getS(X)
        n = size(X,2);
        Ssqr = n/ (n - 1) * getSigmaSqr(X);
    end

    function [m] = find_m(X)
        m = floor(log2(size(X, 2))) + 2;
    end

    function [J, count] = intervalization(X, m)
        sortX = sort(X);
        n = size(sortX,2);
        delta = (sortX(end) - sortX(1)) / m;
        J = sortX(1):delta:sortX(end);
        count = zeros(1,m);

        for i = 1:(size(J,2)-1)
            for j = 1:n
                if (sortX(j) >= J(i) && sortX(j) < J(i+1))
                    count(i) = count(i) + 1;
                end
            end
        end

        count(end) = count(end) + sum(sortX==(sortX(end)));

        for i = 1:size(count,2)
            count(i) = count(i)/(n * delta);
        end

    end

    function [Y] = f(X, MX, DX)
        Y = normpdf(X, MX, sqrt(DX));
    end

    function empF(X)
        [yy, xx] = ecdf(X);
        stairs(xx, yy);
    end
    
    function F(X, MX, DX, m, R)
        delta = R/m;
        Xn = min(X):delta/20:max(X);
        Y = 1/2 * (1 + erf((Xn - MX) / sqrt(2*DX)));
        plot(Xn, Y, '--');
    end
end