@echo off
@title bat ����ִ��git����
D:
cd E:\github\blog\mambamentality8.github.io\source\_posts
git add .
git commit -m %date:~0,4%��%date:~5,2%��%date:~8,2%��
git push origin hexo:hexo