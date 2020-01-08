@echo off
@title bat 交互执行git命令
D:
cd E:\github\blog\mambamentality8.github.io\source\_posts
git add .
git commit -m %date:~0,4%年%date:~5,2%月%date:~8,2%日
git push origin hexo:hexo