function lab2
    clear
    X = [-17.04,-18.29,-17.38,-18.11,-18.96,-17.65,-17.02,-17.22,-16.25,-17.44,-17.69,-17.61,-17.09,-17.19,-16.02,-17.56,-16.94,-17.29,-16.93,-16.61,-19.38,-17.53,-16.39,-17.89,-17.98,-17.04,-16.22,-19.09,-18.91,-17.77,-18.30,-17.44,-18.84,-16.39,-16.13,-18.37,-16.37,-16.70,-17.78,-17.03,-17.76,-17.87,-17.20,-18.44,-17.19,-17.75,-16.81,-17.97,-18.03,-16.87,-16.10,-19.16,-16.51,-18.39,-16.48,-18.08,-17.49,-18.89,-19.09,-17.96,-18.40,-16.96,-18.15,-18.71,-17.81,-17.86,-19.47,-17.86,-17.60,-17.30,-17.60,-17.71,-18.42,-16.88,-16.76,-18.00,-17.97,-16.83,-18.00,-18.08,-17.61,-17.02,-16.73,-17.64,-18.76,-17.68,-18.04,-16.45,-18.79,-18.03,-17.38,-15.27,-15.97,-17.41,-18.61,-18.00,-17.42,-17.77,-19.05,-16.16,-16.27,-18.00,-18.90,-17.05,-17.46,-17.49,-18.20,-17.59,-15.78,-18.88,-18.53,-17.39,-17.83,-18.17,-16.15,-17.66,-17.76,-18.32,-17.70,-17.56];
    N = length(X);
    gamma = 0.9;
    alpha = (1 - gamma)/2;
    mu = findMu(X);
    S2 = findS2(X);
    muArray = getMuArray(X, N);
    varArray = getVarArray(X, N);

    muHigh = findMuHigh(muArray, varArray, alpha, N);
    muLow = findMuLow(muArray, varArray, alpha, N);

    sigma2High = getsigma2High(varArray, alpha, N);
    sigma2Low = getsigma2Low(varArray, alpha, N);

    figure
    hold on;
    plot([1,N], [mu, mu], 'g');
    plot((1:N), muArray, 'r');
    plot((1:N), muLow, 'b');
    plot((1:N), muHigh, 'm');
    legend('mu(x_N)','mu(x_n)','muLow(x_n)','muHigh(x_n)');
    grid on;
    hold off;

    figure
    hold on;
    plot([1,N], [S2, S2], 'g');
    plot((1:N), varArray, 'r');
    plot((1:N), sigma2Low, 'b');
    plot((4:N), sigma2High(4:length(sigma2High)), 'm');
    legend('S^2(x_N)','S^2(x_n)','(sigma^2)Low(x_n)','(sigma^2)High(x_n)');
    grid on;
    hold off;

    N = size(X,2);
    muArray = getMuArray(X, N);
    varArray = getVarArray(X, N);
    muHigh = findMuHigh(muArray, varArray, alpha, N);
    muLow = findMuLow(muArray, varArray, alpha, N);
    sigma2High = getsigma2High(varArray, alpha, N);
    sigma2Low = getsigma2Low(varArray, alpha, N);

    fprintf('mu = %.2f\n', mu);
    fprintf('S^2 = %.2f\n', S2);
    fprintf('mu_low = %.2f\n', muLow(end));
    fprintf('mu_high = %.2f\n', muHigh(end));
    fprintf('sigma^2_low = %.2f\n', sigma2Low(end));
    fprintf('sigma^2_high = %.2f\n', sigma2High(end));

    function mu = findMu(X)
        mu = sum(X)/size(X,2);
    end

    function sigma = getSigmaSqr(X)
        tempMu = findMu(X);
        sigma = sum((X - tempMu) .* (X - tempMu))/size(X,2);
    end

    function S2 = findS2(X)
        n = size(X,2);
        S2 = n/ (n - 1) * getSigmaSqr(X);
    end

    function muArray = getMuArray(X, N)
        muArray = zeros(1,N);
        for i = 1:N
            muArray(i) = findMu(X(1:i));
        end
    end

    function varArray = getVarArray(X, N)
        varArray = zeros(1,N);
        for i = 1:N
            varArray(i) = findS2(X(1:i));
        end
    end

    function muHigh = findMuHigh(muArray, varArray, alpha, N)
        muHigh = zeros(1, N);
        for i = 1:N
            muHigh(i) = muArray(i) + sqrt(varArray(i)./ i) .* tinv(1 - alpha, i - 1);
        end
    end

    function muLow = findMuLow(muArray, varArray, alpha, N)
        muLow = zeros(1, N);
        for i = 1:N
            muLow(i) = muArray(i) + sqrt(varArray(i)./ i) .* tinv(alpha, i - 1);
        end
    end

    function sigma2High = getsigma2High(varArray, alpha, N)
        sigma2High = zeros(1, N);
        for i = 1:N
            sigma2High(i) = varArray(i) .* (i - 1) ./ chi2inv(alpha, i - 1);
        end
    end

    function sigma2Low = getsigma2Low(varArray, alpha, N)
        sigma2Low = zeros(1, N);
        for i = 1:N
            sigma2Low(i) = varArray(i) .* (i - 1) ./ chi2inv(1 - alpha, i - 1);
        end
    end
end