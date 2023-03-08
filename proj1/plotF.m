X1 = -5:0.1:5;
X2 = -5:0.1:5;
Z = zeros(length(X1), length(X2));
for i=1:length(X1)
    for j=1:length(X2)
        Z(i, j) = fbanan([X1(i), X2(j)], -1, 1.5);
    end
end
figure(2)
surf(X1, X2, Z)