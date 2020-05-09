[X,Y] = meshgrid(-2:0.2:2,-2:0.2:2);
Z = X.*exp(-X.^2 - Y.^2);
figure
surface(X,Y,Z)
view(3)
shading interp
xlabel('w1')
ylabel('w2')
zlabel('Loss')
print( '-painters' ,'C:\Users\gche4213\Desktop\ttt.svg','-dsvg')
