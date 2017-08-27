function hough_CircleDetect(filename,radius_range,step_angle,step_radius)
%Hough变换检测圆
%参数：filename：被检测图像文件名
%     radius_range：检测圆的半径范围，1*2矩阵，默认值为[10 100]
%     step_angle：角度步长；默认值为5（角度）
%     step_radius：半径步长；默认值为1（像素）
%功能：从被检测图像中检测出满足指定半径的圆。
if nargin<4
    step_radius=1;
end
if nargin<3
    step_angle=5;
end
if nargin<2
    radius_range=[10 100];
end
radius_min=min(radius_range);
radius_max=max(radius_range);
step_angle=step_angle*pi/180;

I=imread(filename);
[m,n,l]=size(I);
if l>1
    I=rgb2gray(I);
end
BI=edge(I);
[rows,cols]=find(BI);
PointCount=size(rows);

RadiusCount=ceil((radius_max-radius_min)/step_radius);
AngleCount=ceil(2*pi/step_angle);
hough_space=zeros(m,n,RadiusCount);

%Hought变换
%将图像空间（x,y）变换到参数空间（a,b,r）
%a=x-r*cos(theta);
%b=y-r*sin(theta);
for i=1:PointCount
    for r=1:RadiusCount
        for k=1:AngleCount
            a=round(rows(i)-(radius_min+(r-1)*step_radius)*cos(k*step_angle));
            b=round(cols(i)-(radius_min+(r-1)*step_radius)*sin(k*step_angle));
            if(a>0 & a<=m & b>0 &b<=n)
                hough_space(a,b,r)=hough_space(a,b,r)+1;
            end
        end
    end
end

%搜索同一圆上的点
thresh = 0.7;
max_PointCount=max(max(max(hough_space)));
index=find(hough_space>=max_PointCount*thresh);
length=size(index);
hough_circle=zeros(m,n);
size_hough_space = size(hough_space);
for i=1:PointCount
    for k=1:length
        [a,b,r]=ind2sub(size_hough_space,index(k));
        rate=((rows(i)-a)^2+(cols(i)-b)^2)/(radius_min+(r-1)*step_radius)^2;
        if(rate<1.1)
            hough_circle(rows(i),cols(i))=1;
        end
    end
end

figure,imshow(I);
figure,imshow(BI);
figure,imshow(hough_circle);

%hough_CircleDetect('line_circle.bmp')
%hough_CircleDetect('line_circle.bmp',[5,20])
%hough_CircleDetect('line_circle.bmp',[5,100])
%hough_CircleDetect('line_circle.bmp',[5,200])