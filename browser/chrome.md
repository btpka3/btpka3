

## install on MacOS

```bash
# vi ~/.bash_profile
alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
alias chrome-canary="/Applications/Google\ Chrome\ Canary.app/Contents/MacOS/Google\ Chrome\ Canary"
alias chromium="/Applications/Chromium.app/Contents/MacOS/Chromium"

chrome \
    --headless \
    --disable-gpu\
    --remote-debugging-port=9222
```

## install on centos

1. vi `/etc/yum.repos.d/google-chrome.repo`

    ```
    [google-chrome]
    name=google-chrome
    baseurl=http://dl.google.com/linux/chrome/rpm/stable/$basearch
    enabled=1
    gpgcheck=0
    gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub
    ```
1.  Installing Chrome Web Browser

    ```
    yum info google-chrome-stable
    yum install google-chrome-stable
    ```

1. test

    ```bash
    docker exec -it my-chrome bash
    google-chrome --no-sandbox --headless --disable-gpu --dump-dom http://news.163.com
    google-chrome --no-sandbox --headless --disable-gpu --screenshot --window-size=500,1200 http://192.168.0.41:64444/docker/chrome-headless/test.html
    google-chrome --no-sandbox --headless --disable-gpu --print-to-pdf http://news.163.com
    ```




## install on ubuntu

### 参考
* [3rd Party Repository: Google Chrome](https://www.ubuntuupdates.org/ppa/google_chrome?dist=stable)
* [ttf-mscorefonts-installer](https://packages.debian.org/sid/all/ttf-mscorefonts-installer/download)

### 字体来源

```text

# MacOS
/Library/Fonts/
/System/Library/Fonts

# 如何转换ttc 文件为其他格式文件？
使用 http://fontforge.github.io/  : File > Generate Fonts


```

### 安装
1. 基础安装 

    ```bash
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
    sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
    sudo apt-get update
    sudo apt-get install google-chrome-stable
    # 列出系统字体
    fc-list | sort
    more /etc/fonts/fonts.conf
    apt-cache search font
    apt-cache search font | grep lcd
    dpkg-query -l | grep font
   
    apt-cache search typekityu
    apt-get install apt-transport-https
 
    apt-get install -y fonts-noto fonts-noto-cjk
 
    #DEBIAN_FRONTEND=noninteractive apt-get install -y ttf-mscorefonts-installer
    #https://askubuntu.com/questions/829247/cannot-install-the-package-ttf-mscorefonts-installer
    #https://gist.github.com/melvincabatuan/26f3ac4ace4be3a8b48d85a1b3250982
    wget http://ftp.de.debian.org/debian/pool/contrib/m/msttcorefonts/ttf-mscorefonts-installer_3.6_all.deb
    dpkg -i ttf-mscorefonts-installer_3.6_all.deb
    dpkg-query -L ttf-mscorefonts-installer
 
    apt-get install -y fonts-horai-umefont
    apt-get install -y ttf-ubuntu-font-family
    apt-get install -y fonts-ubuntu-font-family-console
    apt-get install -y fonts-droid-fallback
    apt-get install -y fonts-wqy-microhei
    apt-get install -y fonts-roboto
    apt-get install -y xfonts-wqy wqy-zenhei wqy-microhei
    apt-get install -y fonts-arphic-uming fonts-arphic-uka
    apt-get install -y fonts-unfonts-core fonts-unfonts-extra
    apt-get install -y gsfonts gsfonts-x11
 
    # 手动重建字体 cache
    fc-cache -f -v
 
    man fonts.conf
    more /etc/fonts/fonts.conf
    #more /etc/fonts/local.conf
    #more /etc/fonts/language-selector.conf
    ```

1. ubuntu 所携带的字体

    docker 默认安装

    ```text
    # fc-list | sort # 列出系统字体
    /usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf: DejaVu Sans:style=Bold
    /usr/share/fonts/truetype/dejavu/DejaVuSans.ttf: DejaVu Sans:style=Book
    /usr/share/fonts/truetype/dejavu/DejaVuSansMono-Bold.ttf: DejaVu Sans Mono:style=Bold
    /usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf: DejaVu Sans Mono:style=Book
    /usr/share/fonts/truetype/dejavu/DejaVuSerif-Bold.ttf: DejaVu Serif:style=Bold
    /usr/share/fonts/truetype/dejavu/DejaVuSerif.ttf: DejaVu Serif:style=Book
    /usr/share/fonts/truetype/liberation/LiberationMono-Bold.ttf: Liberation Mono:style=Bold
    /usr/share/fonts/truetype/liberation/LiberationMono-BoldItalic.ttf: Liberation Mono:style=Bold Italic
    /usr/share/fonts/truetype/liberation/LiberationMono-Italic.ttf: Liberation Mono:style=Italic
    /usr/share/fonts/truetype/liberation/LiberationMono-Regular.ttf: Liberation Mono:style=Regular
    /usr/share/fonts/truetype/liberation/LiberationSans-Bold.ttf: Liberation Sans:style=Bold
    /usr/share/fonts/truetype/liberation/LiberationSans-BoldItalic.ttf: Liberation Sans:style=Bold Italic
    /usr/share/fonts/truetype/liberation/LiberationSans-Italic.ttf: Liberation Sans:style=Italic
    /usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf: Liberation Sans:style=Regular
    /usr/share/fonts/truetype/liberation/LiberationSansNarrow-Bold.ttf: Liberation Sans Narrow:style=Bold
    /usr/share/fonts/truetype/liberation/LiberationSansNarrow-BoldItalic.ttf: Liberation Sans Narrow:style=Bold Italic
    /usr/share/fonts/truetype/liberation/LiberationSansNarrow-Italic.ttf: Liberation Sans Narrow:style=Italic
    /usr/share/fonts/truetype/liberation/LiberationSansNarrow-Regular.ttf: Liberation Sans Narrow:style=Regular
    /usr/share/fonts/truetype/liberation/LiberationSerif-Bold.ttf: Liberation Serif:style=Bold
    /usr/share/fonts/truetype/liberation/LiberationSerif-BoldItalic.ttf: Liberation Serif:style=Bold Italic
    /usr/share/fonts/truetype/liberation/LiberationSerif-Italic.ttf: Liberation Serif:style=Italic
    /usr/share/fonts/truetype/liberation/LiberationSerif-Regular.ttf: Liberation Serif:style=Regular
    ```
    vs 开发人员日常环境

    ```text
    # fc-list | sort  # 列出系统字体
    /usr/share/fonts/opentype/noto/NotoSansCJK.ttc: Noto Sans CJK JP,Noto Sans CJK JP Black:style=Black,Regular
    /usr/share/fonts/opentype/noto/NotoSansCJK.ttc: Noto Sans CJK JP,Noto Sans CJK JP Bold:style=Bold,Regular
    /usr/share/fonts/opentype/noto/NotoSansCJK.ttc: Noto Sans CJK JP,Noto Sans CJK JP DemiLight:style=DemiLight,Regular
    /usr/share/fonts/opentype/noto/NotoSansCJK.ttc: Noto Sans CJK JP,Noto Sans CJK JP Light:style=Light,Regular
    /usr/share/fonts/opentype/noto/NotoSansCJK.ttc: Noto Sans CJK JP,Noto Sans CJK JP Medium:style=Medium,Regular
    /usr/share/fonts/opentype/noto/NotoSansCJK.ttc: Noto Sans CJK JP,Noto Sans CJK JP Regular:style=Regular
    /usr/share/fonts/opentype/noto/NotoSansCJK.ttc: Noto Sans CJK JP,Noto Sans CJK JP Thin:style=Thin,Regular
    /usr/share/fonts/opentype/noto/NotoSansCJK.ttc: Noto Sans CJK KR,Noto Sans CJK KR Black:style=Black,Regular
    /usr/share/fonts/opentype/noto/NotoSansCJK.ttc: Noto Sans CJK KR,Noto Sans CJK KR Bold:style=Bold,Regular
    /usr/share/fonts/opentype/noto/NotoSansCJK.ttc: Noto Sans CJK KR,Noto Sans CJK KR DemiLight:style=DemiLight,Regular
    /usr/share/fonts/opentype/noto/NotoSansCJK.ttc: Noto Sans CJK KR,Noto Sans CJK KR Light:style=Light,Regular
    /usr/share/fonts/opentype/noto/NotoSansCJK.ttc: Noto Sans CJK KR,Noto Sans CJK KR Medium:style=Medium,Regular
    /usr/share/fonts/opentype/noto/NotoSansCJK.ttc: Noto Sans CJK KR,Noto Sans CJK KR Regular:style=Regular
    /usr/share/fonts/opentype/noto/NotoSansCJK.ttc: Noto Sans CJK KR,Noto Sans CJK KR Thin:style=Thin,Regular
    /usr/share/fonts/opentype/noto/NotoSansCJK.ttc: Noto Sans CJK SC,Noto Sans CJK SC Black:style=Black,Regular
    /usr/share/fonts/opentype/noto/NotoSansCJK.ttc: Noto Sans CJK SC,Noto Sans CJK SC Bold:style=Bold,Regular
    /usr/share/fonts/opentype/noto/NotoSansCJK.ttc: Noto Sans CJK SC,Noto Sans CJK SC DemiLight:style=DemiLight,Regular
    /usr/share/fonts/opentype/noto/NotoSansCJK.ttc: Noto Sans CJK SC,Noto Sans CJK SC Light:style=Light,Regular
    /usr/share/fonts/opentype/noto/NotoSansCJK.ttc: Noto Sans CJK SC,Noto Sans CJK SC Medium:style=Medium,Regular
    /usr/share/fonts/opentype/noto/NotoSansCJK.ttc: Noto Sans CJK SC,Noto Sans CJK SC Regular:style=Regular
    /usr/share/fonts/opentype/noto/NotoSansCJK.ttc: Noto Sans CJK SC,Noto Sans CJK SC Thin:style=Thin,Regular
    /usr/share/fonts/opentype/noto/NotoSansCJK.ttc: Noto Sans CJK TC,Noto Sans CJK TC Black:style=Black,Regular
    /usr/share/fonts/opentype/noto/NotoSansCJK.ttc: Noto Sans CJK TC,Noto Sans CJK TC Bold:style=Bold,Regular
    /usr/share/fonts/opentype/noto/NotoSansCJK.ttc: Noto Sans CJK TC,Noto Sans CJK TC DemiLight:style=DemiLight,Regular
    /usr/share/fonts/opentype/noto/NotoSansCJK.ttc: Noto Sans CJK TC,Noto Sans CJK TC Light:style=Light,Regular
    /usr/share/fonts/opentype/noto/NotoSansCJK.ttc: Noto Sans CJK TC,Noto Sans CJK TC Medium:style=Medium,Regular
    /usr/share/fonts/opentype/noto/NotoSansCJK.ttc: Noto Sans CJK TC,Noto Sans CJK TC Regular:style=Regular
    /usr/share/fonts/opentype/noto/NotoSansCJK.ttc: Noto Sans CJK TC,Noto Sans CJK TC Thin:style=Thin,Regular
    /usr/share/fonts/opentype/noto/NotoSansCJK.ttc: Noto Sans Mono CJK JP,Noto Sans Mono CJK JP Bold:style=Bold,Regular
    /usr/share/fonts/opentype/noto/NotoSansCJK.ttc: Noto Sans Mono CJK JP,Noto Sans Mono CJK JP Regular:style=Regular
    /usr/share/fonts/opentype/noto/NotoSansCJK.ttc: Noto Sans Mono CJK KR,Noto Sans Mono CJK KR Bold:style=Bold,Regular
    /usr/share/fonts/opentype/noto/NotoSansCJK.ttc: Noto Sans Mono CJK KR,Noto Sans Mono CJK KR Regular:style=Regular
    /usr/share/fonts/opentype/noto/NotoSansCJK.ttc: Noto Sans Mono CJK SC,Noto Sans Mono CJK SC Bold:style=Bold,Regular
    /usr/share/fonts/opentype/noto/NotoSansCJK.ttc: Noto Sans Mono CJK SC,Noto Sans Mono CJK SC Regular:style=Regular
    /usr/share/fonts/opentype/noto/NotoSansCJK.ttc: Noto Sans Mono CJK TC,Noto Sans Mono CJK TC Bold:style=Bold,Regular
    /usr/share/fonts/opentype/noto/NotoSansCJK.ttc: Noto Sans Mono CJK TC,Noto Sans Mono CJK TC Regular:style=Regular
    /usr/share/fonts/truetype/arphic/ukai.ttc: AR PL UKai CN:style=Book
    /usr/share/fonts/truetype/arphic/ukai.ttc: AR PL UKai HK:style=Book
    /usr/share/fonts/truetype/arphic/ukai.ttc: AR PL UKai TW MBE:style=Book
    /usr/share/fonts/truetype/arphic/ukai.ttc: AR PL UKai TW:style=Book
    /usr/share/fonts/truetype/arphic/uming.ttc: AR PL UMing CN:style=Light
    /usr/share/fonts/truetype/arphic/uming.ttc: AR PL UMing HK:style=Light
    /usr/share/fonts/truetype/arphic/uming.ttc: AR PL UMing TW MBE:style=Light
    /usr/share/fonts/truetype/arphic/uming.ttc: AR PL UMing TW:style=Light
 
        /usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf: DejaVu Sans:style=Bold
        /usr/share/fonts/truetype/dejavu/DejaVuSansMono-Bold.ttf: DejaVu Sans Mono:style=Bold
        /usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf: DejaVu Sans Mono:style=Book
        /usr/share/fonts/truetype/dejavu/DejaVuSans.ttf: DejaVu Sans:style=Book
        /usr/share/fonts/truetype/dejavu/DejaVuSerif-Bold.ttf: DejaVu Serif:style=Bold
        /usr/share/fonts/truetype/dejavu/DejaVuSerif.ttf: DejaVu Serif:style=Book
 
    /usr/share/fonts/truetype/freefont/FreeMonoBoldOblique.ttf: FreeMono:style=Bold Oblique,получерен наклонен,Negreta cursiva,tučné kurzíva,fed kursiv,Fett-Kursiv,Έντονα Πλάγια,Negrita Cursiva,Lihavoitu Kursivoi,Gras Italique,Félkövér dőlt,Grassetto Corsivo,Vet Cursief,Halvfet Kursiv,Pogrubiona kursywa,Negrito Itálico,gros oblic,Полужирный Курсив,Tučná kurzíva,Fet Kursiv,Kalın İtalik,huruf tebal miring,жирний похилий,polkrepko ležeče,treknais slīpraksts,pusjuodis pasvirasis,Lodi etzana,धृष्ट-तिरछा
    /usr/share/fonts/truetype/freefont/FreeMonoBold.ttf: FreeMono:style=Bold,получерен,negreta,tučné,fed,Fett,Έντονα,Negrita,Lihavoitu,Gras,Félkövér,Grassetto,Vet,Halvfet,Pogrubiony,Negrito,gros,Полужирный,Fet,Kalın,huruf tebal,жирний,polkrepko,treknraksts,pusjuodis,đậm,Lodia,धृष्ट
    /usr/share/fonts/truetype/freefont/FreeMonoOblique.ttf: FreeMono:style=Oblique,наклонен,cursiva,kurzíva,kursiv,Πλάγια,Kursivoitu,Italique,Dőlt,Corsivo,Cursief,Kursywa,Itálico,oblic,Курсив,İtalik,huruf miring,похилий,ležeče,slīpraksts,pasvirasis,nghiêng,Etzana,तिरछा
    /usr/share/fonts/truetype/freefont/FreeMono.ttf: FreeMono:style=Regular,нормален,normal,obyčejné,Standard,µεσαία,Normaali,Normál,Normale,Standaard,Normalny,Обычный,Normálne,menengah,прямій,navadno,vidējs,normalusis,thường,Arrunta,सामान्य
    /usr/share/fonts/truetype/freefont/FreeSansBoldOblique.ttf: FreeSans:style=Bold Oblique,получерен наклонен,negreta cursiva,tučné kurzíva,fed kursiv,Fett-Kursiv,Έντονη Πλάγια,Negrita Cursiva,Lihavoitu Kursivoi,Gras Italique,Félkövér dőlt,Grassetto Corsivo,Vet Cursief,Halvfet Kursiv,Pogrubiona kursywa,Negrito Itálico,gros oblic,Обычный Курсив,Tučná kurzíva,Fet Kursiv,Kalın İtalik,huruf tebal miring,жирний похилий,polkrepko ležeče,treknais  slīpraksts,pusjuodis pasvirasis,nghiêng đậm,Lodi etzana,धृष्ट-तिरछा
    /usr/share/fonts/truetype/freefont/FreeSansBold.ttf: FreeSans:style=Bold,получерен,negreta,tučné,fed,Fett,Έντονα,Negrita,Lihavoitu,Gras,Félkövér,Grassetto,Vet,Halvfet,Pogrubiony,Negrito,gros,Полужирный,Fet,Kalın,huruf tebal,жирний,Krepko,treknraksts,pusjuodis,đậm,Lodia,धृष्ट
    /usr/share/fonts/truetype/freefont/FreeSansOblique.ttf: FreeSans:style=Oblique,наклонен,negreta cursiva,kurzíva,kursiv,Πλάγια,Cursiva,Kursivoitu,Italique,Dőlt,Corsivo,Cursief,kursywa,Itálico,oblic,Курсив,İtalik,huruf miring,похилий,Ležeče,slīpraksts,pasvirasis,nghiêng,Etzana,तिरछा
    /usr/share/fonts/truetype/freefont/FreeSans.ttf: FreeSans:style=Regular,нормален,Normal,obyčejné,Mittel,µεσαία,Normaali,Normál,Medio,Gemiddeld,Odmiana Zwykła,Обычный,Normálne,menengah,прямій,Navadno,vidējs,normalusis,vừa,Arrunta,सामान्य
    /usr/share/fonts/truetype/freefont/FreeSerifBoldItalic.ttf: FreeSerif:style=Bold Italic,получерен курсивен,negreta cursiva,tučné kurzíva,fed kursiv,Fett-Kursiv,Negrita Cursiva,Lihavoitu Kursivoi,Gras Italique,Félkövér dőlt,Grassetto Corsivo,Vet Cursief,Halvfet Kursiv,Pogrubiona kursywa,Negrito Itálico,gros cursiv,Обычный Курсив,Tučná kurzíva,Fet Kursiv,ตัวเอียงหนา,Kalın İtalik,huruf tebal kursif,жирний курсив,Polkrepko Pežeče,treknais kursīvs,pusjuodis kursyvas,nghiêng đậm,Lodi etzana,धृष्ट-तिरछा
    /usr/share/fonts/truetype/freefont/FreeSerifBold.ttf: FreeSerif:style=Bold,получерен,negreta,tučné,fed,Fett,Negrita,Lihavoitu,Gras,Félkövér,Grassetto,Vet,Halvfet,Pogrubiony,Negrito,gros,Обычный,Fet,ตัวหนา,Kalın,huruf tebal,жирний,Polkrepko,treknraksts,pusjuodis,ضخیم,đậm,Lodia,धृष्ट
    /usr/share/fonts/truetype/freefont/FreeSerifItalic.ttf: FreeSerif:style=Italic,курсивен,cursiva,kurzíva,kursiv,Λειψίας,Kursivoitu,Italique,Dőlt,Corsivo,Cursief,kursywa,Itálico,cursiv,Курсив,ตัวเอียง,İtalik,kursif,Ležeče,kursīvs,kursivas,nghiêng,Etzana,तिरछा
    /usr/share/fonts/truetype/freefont/FreeSerif.ttf: FreeSerif:style=Regular,нормален,normal,obyčejné,Mittel,µεσαία,Normaali,Normál,Normale,Gemiddeld,odmiana zwykła,Обычный,Normálne,ปกติ,menengah,прямій,Navadno,vidējs,normalusis,عادی,vừa,Arrunta,सामान्य
    /usr/share/fonts/truetype/horai-umefont/ume-pgc4.ttf: Ume P Gothic C4,梅PゴシックC4:style=Regular
    /usr/share/fonts/truetype/horai-umefont/ume-pgc5.ttf: Ume P Gothic C5,梅PゴシックC5:style=Medium
    /usr/share/fonts/truetype/horai-umefont/ume-pgo4.ttf: Ume P Gothic,梅Pゴシック:style=Regular
    /usr/share/fonts/truetype/horai-umefont/ume-pgo5.ttf: Ume P Gothic O5,梅PゴシックO5:style=Medium
    /usr/share/fonts/truetype/horai-umefont/ume-pgs4.ttf: Ume P Gothic S4,梅PゴシックS4:style=Regular
    /usr/share/fonts/truetype/horai-umefont/ume-pgs5.ttf: Ume P Gothic S5,梅PゴシックS5:style=Medium
    /usr/share/fonts/truetype/horai-umefont/ume-pmo3.ttf: Ume P Mincho,梅P明朝:style=Regular
    /usr/share/fonts/truetype/horai-umefont/ume-pms3.ttf: Ume P Mincho S3,梅P明朝S3:style=Regular
    /usr/share/fonts/truetype/horai-umefont/ume-tgc4.ttf: Ume Gothic C4,梅ゴシックC4:style=Regular
    /usr/share/fonts/truetype/horai-umefont/ume-tgc5.ttf: Ume Gothic C5,梅ゴシックC5:style=Medium
    /usr/share/fonts/truetype/horai-umefont/ume-tgo4.ttf: Ume Gothic,梅ゴシック:style=Regular
    /usr/share/fonts/truetype/horai-umefont/ume-tgo5.ttf: Ume Gothic O5,梅ゴシックO5:style=Medium
    /usr/share/fonts/truetype/horai-umefont/ume-tgs4.ttf: Ume Gothic S4,梅ゴシックS4:style=Regular
    /usr/share/fonts/truetype/horai-umefont/ume-tgs5.ttf: Ume Gothic S5,梅ゴシックS5:style=Medium
    /usr/share/fonts/truetype/horai-umefont/ume-tmo3.ttf: Ume Mincho,梅明朝:style=Regular
    /usr/share/fonts/truetype/horai-umefont/ume-tms3.ttf: Ume Mincho S3,梅明朝S3:style=Regular
    /usr/share/fonts/truetype/horai-umefont/ume-ugo4.ttf: Ume UI Gothic,梅UIゴシック:style=Regular
    /usr/share/fonts/truetype/horai-umefont/ume-ugo5.ttf: Ume UI Gothic O5,梅UIゴシックO5:style=Medium
    
        /usr/share/fonts/truetype/liberation/LiberationMono-BoldItalic.ttf: Liberation Mono:style=Bold Italic
        /usr/share/fonts/truetype/liberation/LiberationMono-Bold.ttf: Liberation Mono:style=Bold
        /usr/share/fonts/truetype/liberation/LiberationMono-Italic.ttf: Liberation Mono:style=Italic
        /usr/share/fonts/truetype/liberation/LiberationMono-Regular.ttf: Liberation Mono:style=Regular
        /usr/share/fonts/truetype/liberation/LiberationSans-BoldItalic.ttf: Liberation Sans:style=Bold Italic
        /usr/share/fonts/truetype/liberation/LiberationSans-Bold.ttf: Liberation Sans:style=Bold
        /usr/share/fonts/truetype/liberation/LiberationSans-Italic.ttf: Liberation Sans:style=Italic
        /usr/share/fonts/truetype/liberation/LiberationSansNarrow-BoldItalic.ttf: Liberation Sans Narrow:style=Bold Italic
        /usr/share/fonts/truetype/liberation/LiberationSansNarrow-Bold.ttf: Liberation Sans Narrow:style=Bold
        /usr/share/fonts/truetype/liberation/LiberationSansNarrow-Italic.ttf: Liberation Sans Narrow:style=Italic
        /usr/share/fonts/truetype/liberation/LiberationSansNarrow-Regular.ttf: Liberation Sans Narrow:style=Regular
        /usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf: Liberation Sans:style=Regular
        /usr/share/fonts/truetype/liberation/LiberationSerif-BoldItalic.ttf: Liberation Serif:style=Bold Italic
        /usr/share/fonts/truetype/liberation/LiberationSerif-Bold.ttf: Liberation Serif:style=Bold
        /usr/share/fonts/truetype/liberation/LiberationSerif-Italic.ttf: Liberation Serif:style=Italic
        /usr/share/fonts/truetype/liberation/LiberationSerif-Regular.ttf: Liberation Serif:style=Regular
 
    /usr/share/fonts/truetype/msttcorefonts/Andale_Mono.ttf: Andale Mono:style=Regular,Normal,obyčejné,Standard,Κανονικά,Normaali,Normál,Normale,Standaard,Normalny,Обычный,Normálne,Navadno,Arrunta
    /usr/share/fonts/truetype/msttcorefonts/andalemo.ttf: Andale Mono:style=Regular,Normal,obyčejné,Standard,Κανονικά,Normaali,Normál,Normale,Standaard,Normalny,Обычный,Normálne,Navadno,Arrunta
    /usr/share/fonts/truetype/msttcorefonts/arialbd.ttf: Arial:style=Bold,Negreta,tučné,fed,Fett,Έντονα,Negrita,Lihavoitu,Gras,Félkövér,Grassetto,Vet,Halvfet,Pogrubiony,Negrito,Полужирный,Fet,Kalın,Krepko,đậm,Lodia
    /usr/share/fonts/truetype/msttcorefonts/arialbi.ttf: Arial:style=Bold Italic,Negreta cursiva,tučné kurzíva,fed kursiv,Fett Kursiv,Έντονα Πλάγια,Negrita Cursiva,Lihavoitu Kursivoi,Gras Italique,Félkövér dőlt,Grassetto Corsivo,Vet Cursief,Halvfet Kursiv,Pogrubiona kursywa,Negrito Itálico,Полужирный Курсив,Tučná kurzíva,Fet Kursiv,Kalın İtalik,Krepko poševno,nghiêng đậm,Lodi etzana
    /usr/share/fonts/truetype/msttcorefonts/Arial_Black.ttf: Arial Black:style=Regular,Normal,obyčejné,Standard,Κανονικά,Normaali,Normál,Normale,Standaard,Normalny,Обычный,Normálne,Navadno,Arrunta
    /usr/share/fonts/truetype/msttcorefonts/Arial_Bold_Italic.ttf: Arial:style=Bold Italic,Negreta cursiva,tučné kurzíva,fed kursiv,Fett Kursiv,Έντονα Πλάγια,Negrita Cursiva,Lihavoitu Kursivoi,Gras Italique,Félkövér dőlt,Grassetto Corsivo,Vet Cursief,Halvfet Kursiv,Pogrubiona kursywa,Negrito Itálico,Полужирный Курсив,Tučná kurzíva,Fet Kursiv,Kalın İtalik,Krepko poševno,nghiêng đậm,Lodi etzana
    /usr/share/fonts/truetype/msttcorefonts/Arial_Bold.ttf: Arial:style=Bold,Negreta,tučné,fed,Fett,Έντονα,Negrita,Lihavoitu,Gras,Félkövér,Grassetto,Vet,Halvfet,Pogrubiony,Negrito,Полужирный,Fet,Kalın,Krepko,đậm,Lodia
    /usr/share/fonts/truetype/msttcorefonts/Arial_Italic.ttf: Arial:style=Italic,Cursiva,kurzíva,kursiv,Πλάγια,Kursivoitu,Italique,Dőlt,Corsivo,Cursief,Kursywa,Itálico,Курсив,İtalik,Poševno,nghiêng,Etzana
    /usr/share/fonts/truetype/msttcorefonts/ariali.ttf: Arial:style=Italic,Cursiva,kurzíva,kursiv,Πλάγια,Kursivoitu,Italique,Dőlt,Corsivo,Cursief,Kursywa,Itálico,Курсив,İtalik,Poševno,nghiêng,Etzana
    /usr/share/fonts/truetype/msttcorefonts/Arial.ttf: Arial:style=Regular,Normal,obyčejné,Standard,Κανονικά,Normaali,Normál,Normale,Standaard,Normalny,Обычный,Normálne,Navadno,thường,Arrunta
    /usr/share/fonts/truetype/msttcorefonts/ariblk.ttf: Arial Black:style=Regular,Normal,obyčejné,Standard,Κανονικά,Normaali,Normál,Normale,Standaard,Normalny,Обычный,Normálne,Navadno,Arrunta
    /usr/share/fonts/truetype/msttcorefonts/comicbd.ttf: Comic Sans MS:style=Bold,Negreta,tučné,fed,Fett,Έντονα,Negrita,Lihavoitu,Gras,Félkövér,Grassetto,Vet,Halvfet,Pogrubiony,Negrito,Полужирный,Fet,Kalın,Krepko,Lodia
    /usr/share/fonts/truetype/msttcorefonts/Comic_Sans_MS_Bold.ttf: Comic Sans MS:style=Bold,Negreta,tučné,fed,Fett,Έντονα,Negrita,Lihavoitu,Gras,Félkövér,Grassetto,Vet,Halvfet,Pogrubiony,Negrito,Полужирный,Fet,Kalın,Krepko,Lodia
    /usr/share/fonts/truetype/msttcorefonts/Comic_Sans_MS.ttf: Comic Sans MS:style=Regular,Normal,obyčejné,Standard,Κανονικά,Normaali,Normál,Normale,Standaard,Normalny,Обычный,Normálne,Navadno,Arrunta
    /usr/share/fonts/truetype/msttcorefonts/comic.ttf: Comic Sans MS:style=Regular,Normal,obyčejné,Standard,Κανονικά,Normaali,Normál,Normale,Standaard,Normalny,Обычный,Normálne,Navadno,Arrunta
    /usr/share/fonts/truetype/msttcorefonts/courbd.ttf: Courier New:style=Bold,Negreta,tučné,fed,Fett,Έντονα,Negrita,Lihavoitu,Gras,Félkövér,Grassetto,Vet,Halvfet,Pogrubiony,Negrito,Полужирный,Fet,Kalın,Krepko,đậm,Lodia
    /usr/share/fonts/truetype/msttcorefonts/courbi.ttf: Courier New:style=Bold Italic,Negreta cursiva,tučné kurzíva,fed kursiv,Fett Kursiv,Έντονα Πλάγια,Negrita Cursiva,Lihavoitu Kursivoi,Gras Italique,Félkövér dőlt,Grassetto Corsivo,Vet Cursief,Halvfet Kursiv,Pogrubiona kursywa,Negrito Itálico,Полужирный Курсив,Tučná kurzíva,Fet Kursiv,Kalın İtalik,Krepko poševno,Lodi etzana
    /usr/share/fonts/truetype/msttcorefonts/Courier_New_Bold_Italic.ttf: Courier New:style=Bold Italic,Negreta cursiva,tučné kurzíva,fed kursiv,Fett Kursiv,Έντονα Πλάγια,Negrita Cursiva,Lihavoitu Kursivoi,Gras Italique,Félkövér dőlt,Grassetto Corsivo,Vet Cursief,Halvfet Kursiv,Pogrubiona kursywa,Negrito Itálico,Полужирный Курсив,Tučná kurzíva,Fet Kursiv,Kalın İtalik,Krepko poševno,Lodi etzana
    /usr/share/fonts/truetype/msttcorefonts/Courier_New_Bold.ttf: Courier New:style=Bold,Negreta,tučné,fed,Fett,Έντονα,Negrita,Lihavoitu,Gras,Félkövér,Grassetto,Vet,Halvfet,Pogrubiony,Negrito,Полужирный,Fet,Kalın,Krepko,đậm,Lodia
    /usr/share/fonts/truetype/msttcorefonts/Courier_New_Italic.ttf: Courier New:style=Italic,Cursiva,kurzíva,kursiv,Πλάγια,Kursivoitu,Italique,Dőlt,Corsivo,Cursief,Kursywa,Itálico,Курсив,İtalik,Poševno,nghiêng,Etzana
    /usr/share/fonts/truetype/msttcorefonts/Courier_New.ttf: Courier New:style=Regular,Normal,obyčejné,Standard,Κανονικά,Normaali,Normál,Normale,Standaard,Normalny,Обычный,Normálne,Navadno,thường,Arrunta
    /usr/share/fonts/truetype/msttcorefonts/couri.ttf: Courier New:style=Italic,Cursiva,kurzíva,kursiv,Πλάγια,Kursivoitu,Italique,Dőlt,Corsivo,Cursief,Kursywa,Itálico,Курсив,İtalik,Poševno,nghiêng,Etzana
    /usr/share/fonts/truetype/msttcorefonts/cour.ttf: Courier New:style=Regular,Normal,obyčejné,Standard,Κανονικά,Normaali,Normál,Normale,Standaard,Normalny,Обычный,Normálne,Navadno,thường,Arrunta
    /usr/share/fonts/truetype/msttcorefonts/Georgia_Bold_Italic.ttf: Georgia:style=Bold Italic,Negreta cursiva,tučné kurzíva,fed kursiv,Fett Kursiv,Έντονα Πλάγια,Negrita Cursiva,Lihavoitu Kursivoi,Gras Italique,Félkövér dőlt,Grassetto Corsivo,Vet Cursief,Halvfet Kursiv,Pogrubiona kursywa,Negrito Itálico,Полужирный Курсив,Tučná kurzíva,Fet Kursiv,Kalın İtalik,Krepko poševno,Lodi etzana
    /usr/share/fonts/truetype/msttcorefonts/Georgia_Bold.ttf: Georgia:style=Bold,Negreta,tučné,fed,Fett,Έντονα,Negrita,Lihavoitu,Gras,Félkövér,Grassetto,Vet,Halvfet,Pogrubiony,Negrito,Полужирный,Fet,Kalın,Krepko,Lodia
    /usr/share/fonts/truetype/msttcorefonts/georgiab.ttf: Georgia:style=Bold,Negreta,tučné,fed,Fett,Έντονα,Negrita,Lihavoitu,Gras,Félkövér,Grassetto,Vet,Halvfet,Pogrubiony,Negrito,Полужирный,Fet,Kalın,Krepko,Lodia
    /usr/share/fonts/truetype/msttcorefonts/Georgia_Italic.ttf: Georgia:style=Italic,Cursiva,kurzíva,kursiv,Πλάγια,Kursivoitu,Italique,Dőlt,Corsivo,Cursief,Kursywa,Itálico,Курсив,İtalik,Poševno,Etzana
    /usr/share/fonts/truetype/msttcorefonts/georgiai.ttf: Georgia:style=Italic,Cursiva,kurzíva,kursiv,Πλάγια,Kursivoitu,Italique,Dőlt,Corsivo,Cursief,Kursywa,Itálico,Курсив,İtalik,Poševno,Etzana
    /usr/share/fonts/truetype/msttcorefonts/Georgia.ttf: Georgia:style=Regular,Normal,obyčejné,Standard,Κανονικά,Normaali,Normál,Normale,Standaard,Normalny,Обычный,Normálne,Navadno,Arrunta
    /usr/share/fonts/truetype/msttcorefonts/georgiaz.ttf: Georgia:style=Bold Italic,Negreta cursiva,tučné kurzíva,fed kursiv,Fett Kursiv,Έντονα Πλάγια,Negrita Cursiva,Lihavoitu Kursivoi,Gras Italique,Félkövér dőlt,Grassetto Corsivo,Vet Cursief,Halvfet Kursiv,Pogrubiona kursywa,Negrito Itálico,Полужирный Курсив,Tučná kurzíva,Fet Kursiv,Kalın İtalik,Krepko poševno,Lodi etzana
    /usr/share/fonts/truetype/msttcorefonts/Impact.ttf: Impact:style=Regular,Normal,obyčejné,Standard,Κανονικά,Normaali,Normál,Normale,Standaard,Normalny,Обычный,Normálne,Navadno,Arrunta
    /usr/share/fonts/truetype/msttcorefonts/timesbd.ttf: Times New Roman:style=Bold,Negreta,tučné,fed,Fett,Έντονα,Negrita,Lihavoitu,Gras,Félkövér,Grassetto,Vet,Halvfet,Pogrubiona,Negrito,Полужирный,Fet,Kalın,Krepko,đậm,Lodia
    /usr/share/fonts/truetype/msttcorefonts/timesbi.ttf: Times New Roman:style=Bold Italic,Negreta cursiva,tučné kurzíva,fed kursiv,Fett Kursiv,Έντονα Πλάγια,Negrita Cursiva,Lihavoitu Kursivoi,Gras Italique,Félkövér dőlt,Grassetto Corsivo,Vet Cursief,Halvfet Kursiv,Pogrubiona kursywa,Negrito Itálico,Полужирный Курсив,Tučná kurzíva,Fet Kursiv,Kalın İtalik,Krepko poševno,nghiêng đậm,Lodi etzana
    /usr/share/fonts/truetype/msttcorefonts/timesi.ttf: Times New Roman:style=Italic,cursiva,kurzíva,kursiv,Πλάγια,Kursivoitu,Italique,Dőlt,Corsivo,Cursief,kursywa,Itálico,Курсив,İtalik,Poševno,nghiêng,Etzana
    /usr/share/fonts/truetype/msttcorefonts/Times_New_Roman_Bold_Italic.ttf: Times New Roman:style=Bold Italic,Negreta cursiva,tučné kurzíva,fed kursiv,Fett Kursiv,Έντονα Πλάγια,Negrita Cursiva,Lihavoitu Kursivoi,Gras Italique,Félkövér dőlt,Grassetto Corsivo,Vet Cursief,Halvfet Kursiv,Pogrubiona kursywa,Negrito Itálico,Полужирный Курсив,Tučná kurzíva,Fet Kursiv,Kalın İtalik,Krepko poševno,nghiêng đậm,Lodi etzana
    /usr/share/fonts/truetype/msttcorefonts/Times_New_Roman_Bold.ttf: Times New Roman:style=Bold,Negreta,tučné,fed,Fett,Έντονα,Negrita,Lihavoitu,Gras,Félkövér,Grassetto,Vet,Halvfet,Pogrubiona,Negrito,Полужирный,Fet,Kalın,Krepko,đậm,Lodia
    /usr/share/fonts/truetype/msttcorefonts/Times_New_Roman_Italic.ttf: Times New Roman:style=Italic,cursiva,kurzíva,kursiv,Πλάγια,Kursivoitu,Italique,Dőlt,Corsivo,Cursief,kursywa,Itálico,Курсив,İtalik,Poševno,nghiêng,Etzana
    /usr/share/fonts/truetype/msttcorefonts/Times_New_Roman.ttf: Times New Roman:style=Regular,Normal,obyčejné,Standard,Κανονικά,Normaali,Normál,Normale,Standaard,Normalny,Обычный,Normálne,Navadno,thường,Arrunta
    /usr/share/fonts/truetype/msttcorefonts/times.ttf: Times New Roman:style=Regular,Normal,obyčejné,Standard,Κανονικά,Normaali,Normál,Normale,Standaard,Normalny,Обычный,Normálne,Navadno,thường,Arrunta
    /usr/share/fonts/truetype/msttcorefonts/trebucbd.ttf: Trebuchet MS:style=Bold,Negreta,tučné,fed,Fett,Έντονα,Negrita,Lihavoitu,Gras,Félkövér,Grassetto,Vet,Halvfet,Pogrubiony,Negrito,Полужирный,Fet,Kalın,Krepko,Lodia
    /usr/share/fonts/truetype/msttcorefonts/trebucbi.ttf: Trebuchet MS:style=Bold Italic,Negreta cursiva,tučné kurzíva,fed kursiv,Fett Kursiv,Έντονα Πλάγια,Negrita Cursiva,Lihavoitu Kursivoi,Gras Italique,Félkövér dőlt,Grassetto Corsivo,Vet Cursief,Halvfet Kursiv,Pogrubiona kursywa,Negrito Itálico,Полужирный Курсив,Tučná kurzíva,Fet Kursiv,Kalın İtalik,Krepko poševno,Lodi etzana
    /usr/share/fonts/truetype/msttcorefonts/Trebuchet_MS_Bold_Italic.ttf: Trebuchet MS:style=Bold Italic,Negreta cursiva,tučné kurzíva,fed kursiv,Fett Kursiv,Έντονα Πλάγια,Negrita Cursiva,Lihavoitu Kursivoi,Gras Italique,Félkövér dőlt,Grassetto Corsivo,Vet Cursief,Halvfet Kursiv,Pogrubiona kursywa,Negrito Itálico,Полужирный Курсив,Tučná kurzíva,Fet Kursiv,Kalın İtalik,Krepko poševno,Lodi etzana
    /usr/share/fonts/truetype/msttcorefonts/Trebuchet_MS_Bold.ttf: Trebuchet MS:style=Bold,Negreta,tučné,fed,Fett,Έντονα,Negrita,Lihavoitu,Gras,Félkövér,Grassetto,Vet,Halvfet,Pogrubiony,Negrito,Полужирный,Fet,Kalın,Krepko,Lodia
    /usr/share/fonts/truetype/msttcorefonts/Trebuchet_MS_Italic.ttf: Trebuchet MS:style=Italic,Cursiva,kurzíva,kursiv,Πλάγια,Kursivoitu,Italique,Dőlt,Corsivo,Cursief,Kursywa,Itálico,Курсив,İtalik,Poševno,Etzana
    /usr/share/fonts/truetype/msttcorefonts/Trebuchet_MS.ttf: Trebuchet MS:style=Regular,Normal,obyčejné,Standard,Κανονικά,Normaali,Normál,Normale,Standaard,Normalny,Обычный,Normálne,Navadno,Arrunta
    /usr/share/fonts/truetype/msttcorefonts/trebucit.ttf: Trebuchet MS:style=Italic,Cursiva,kurzíva,kursiv,Πλάγια,Kursivoitu,Italique,Dőlt,Corsivo,Cursief,Kursywa,Itálico,Курсив,İtalik,Poševno,Etzana
    /usr/share/fonts/truetype/msttcorefonts/trebuc.ttf: Trebuchet MS:style=Regular,Normal,obyčejné,Standard,Κανονικά,Normaali,Normál,Normale,Standaard,Normalny,Обычный,Normálne,Navadno,Arrunta
    /usr/share/fonts/truetype/msttcorefonts/Verdana_Bold_Italic.ttf: Verdana:style=Bold Italic,Negreta cursiva,tučné kurzíva,fed kursiv,Fett Kursiv,Έντονα Πλάγια,Negrita Cursiva,Lihavoitu Kursivoi,Gras Italique,Félkövér dőlt,Grassetto Corsivo,Vet Cursief,Halvfet Kursiv,Pogrubiona kursywa,Negrito Itálico,Полужирный Курсив,Tučná kurzíva,Fet Kursiv,Kalın İtalik,Krepko poševno,Lodi etzana
    /usr/share/fonts/truetype/msttcorefonts/Verdana_Bold.ttf: Verdana:style=Bold,Negreta,tučné,fed,Fett,Έντονα,Negrita,Lihavoitu,Gras,Félkövér,Grassetto,Vet,Halvfet,Pogrubiony,Negrito,Полужирный,Fet,Kalın,Krepko,Lodia
    /usr/share/fonts/truetype/msttcorefonts/verdanab.ttf: Verdana:style=Bold,Negreta,tučné,fed,Fett,Έντονα,Negrita,Lihavoitu,Gras,Félkövér,Grassetto,Vet,Halvfet,Pogrubiony,Negrito,Полужирный,Fet,Kalın,Krepko,Lodia
    /usr/share/fonts/truetype/msttcorefonts/Verdana_Italic.ttf: Verdana:style=Italic,Cursiva,kurzíva,kursiv,Πλάγια,Kursivoitu,Italique,Dőlt,Corsivo,Cursief,Kursywa,Itálico,Курсив,İtalik,Poševno,Etzana
    /usr/share/fonts/truetype/msttcorefonts/verdanai.ttf: Verdana:style=Italic,Cursiva,kurzíva,kursiv,Πλάγια,Kursivoitu,Italique,Dőlt,Corsivo,Cursief,Kursywa,Itálico,Курсив,İtalik,Poševno,Etzana
    /usr/share/fonts/truetype/msttcorefonts/Verdana.ttf: Verdana:style=Regular,Normal,obyčejné,Standard,Κανονικά,Normaali,Normál,Normale,Standaard,Normalny,Обычный,Normálne,Navadno,Arrunta
    /usr/share/fonts/truetype/msttcorefonts/verdanaz.ttf: Verdana:style=Bold Italic,Negreta cursiva,tučné kurzíva,fed kursiv,Fett Kursiv,Έντονα Πλάγια,Negrita Cursiva,Lihavoitu Kursivoi,Gras Italique,Félkövér dőlt,Grassetto Corsivo,Vet Cursief,Halvfet Kursiv,Pogrubiona kursywa,Negrito Itálico,Полужирный Курсив,Tučná kurzíva,Fet Kursiv,Kalın İtalik,Krepko poševno,Lodi etzana
    /usr/share/fonts/truetype/msttcorefonts/Webdings.ttf: Webdings:style=Regular,Normal,obyčejné,Standard,Κανονικά,Normaali,Normál,Normale,Standaard,Normalny,Обычный,Normálne,Navadno,Arrunta
    /usr/share/fonts/truetype/nanum/NanumBarunGothicBold.ttf: NanumBarunGothic,나눔바른고딕:style=Bold
    /usr/share/fonts/truetype/nanum/NanumBarunGothic.ttf: NanumBarunGothic,나눔바른고딕:style=Regular
    /usr/share/fonts/truetype/nanum/NanumGothicBold.ttf: NanumGothic,나눔고딕:style=Bold
    /usr/share/fonts/truetype/nanum/NanumGothic.ttf: NanumGothic,나눔고딕:style=Regular
    /usr/share/fonts/truetype/nanum/NanumMyeongjoBold.ttf: NanumMyeongjo,나눔명조:style=Bold
    /usr/share/fonts/truetype/nanum/NanumMyeongjo.ttf: NanumMyeongjo,나눔명조:style=Regular
    /usr/share/fonts/truetype/ubuntu-font-family/Ubuntu-BI.ttf: Ubuntu:style=Bold Italic
    /usr/share/fonts/truetype/ubuntu-font-family/Ubuntu-B.ttf: Ubuntu:style=Bold
    /usr/share/fonts/truetype/ubuntu-font-family/Ubuntu-C.ttf: Ubuntu Condensed:style=Regular
    /usr/share/fonts/truetype/ubuntu-font-family/Ubuntu-LI.ttf: Ubuntu,Ubuntu Light:style=Light Italic,Italic
    /usr/share/fonts/truetype/ubuntu-font-family/Ubuntu-L.ttf: Ubuntu,Ubuntu Light:style=Light,Regular
    /usr/share/fonts/truetype/ubuntu-font-family/Ubuntu-MI.ttf: Ubuntu,Ubuntu Light:style=Medium Italic,Bold Italic
    /usr/share/fonts/truetype/ubuntu-font-family/UbuntuMono-BI.ttf: Ubuntu Mono:style=Bold Italic
    /usr/share/fonts/truetype/ubuntu-font-family/UbuntuMono-B.ttf: Ubuntu Mono:style=Bold
    /usr/share/fonts/truetype/ubuntu-font-family/UbuntuMono-RI.ttf: Ubuntu Mono:style=Italic
    /usr/share/fonts/truetype/ubuntu-font-family/UbuntuMono-R.ttf: Ubuntu Mono:style=Regular
    /usr/share/fonts/truetype/ubuntu-font-family/Ubuntu-M.ttf: Ubuntu,Ubuntu Light:style=Medium,Bold
    /usr/share/fonts/truetype/ubuntu-font-family/Ubuntu-RI.ttf: Ubuntu:style=Italic
    /usr/share/fonts/truetype/ubuntu-font-family/Ubuntu-R.ttf: Ubuntu:style=Regular
    /usr/share/fonts/truetype/unfonts-core/UnBatangBold.ttf: UnBatang,은 바탕:style=Bold
    /usr/share/fonts/truetype/unfonts-core/UnBatang.ttf: UnBatang,은 바탕:style=Regular
    /usr/share/fonts/truetype/unfonts-core/UnDinaruBold.ttf: UnDinaru,은 디나루:style=Bold
    /usr/share/fonts/truetype/unfonts-core/UnDinaruLight.ttf: UnDinaru,은 디나루:style=Light,Bold
    /usr/share/fonts/truetype/unfonts-core/UnDinaru.ttf: UnDinaru,은 디나루:style=Regular
    /usr/share/fonts/truetype/unfonts-core/UnDotumBold.ttf: UnDotum,은 돋움:style=Bold
    /usr/share/fonts/truetype/unfonts-core/UnDotum.ttf: UnDotum,은 돋움:style=Regular
    /usr/share/fonts/truetype/unfonts-core/UnGraphicBold.ttf: UnGraphic,은 그래픽:style=Bold
    /usr/share/fonts/truetype/unfonts-core/UnGraphic.ttf: UnGraphic,은 그래픽:style=Regular
    /usr/share/fonts/truetype/unfonts-core/UnGungseo.ttf: UnGungseo,은 궁서:style=Regular
    /usr/share/fonts/truetype/unfonts-core/UnPilgiBold.ttf: UnPilgi,은 필기:style=Bold
    /usr/share/fonts/truetype/unfonts-core/UnPilgi.ttf: UnPilgi,은 필기:style=Regular
    /usr/share/fonts/truetype/wqy/wqy-microhei.ttc: 文泉驿等宽微米黑,文泉驛等寬微米黑,WenQuanYi Micro Hei Mono:style=Regular
    /usr/share/fonts/truetype/wqy/wqy-microhei.ttc: 文泉驿微米黑,文泉驛微米黑,WenQuanYi Micro Hei:style=Regular
    /usr/share/fonts/type1/gsfonts/a010013l.pfb: URW Gothic L:style=Book
    /usr/share/fonts/type1/gsfonts/a010015l.pfb: URW Gothic L:style=Demi
    /usr/share/fonts/type1/gsfonts/a010033l.pfb: URW Gothic L:style=Book Oblique
    /usr/share/fonts/type1/gsfonts/a010035l.pfb: URW Gothic L:style=Demi Oblique
    /usr/share/fonts/type1/gsfonts/b018012l.pfb: URW Bookman L:style=Light
    /usr/share/fonts/type1/gsfonts/b018015l.pfb: URW Bookman L:style=Demi Bold
    /usr/share/fonts/type1/gsfonts/b018032l.pfb: URW Bookman L:style=Light Italic
    /usr/share/fonts/type1/gsfonts/b018035l.pfb: URW Bookman L:style=Demi Bold Italic
    /usr/share/fonts/type1/gsfonts/c059013l.pfb: Century Schoolbook L:style=Roman
    /usr/share/fonts/type1/gsfonts/c059016l.pfb: Century Schoolbook L:style=Bold
    /usr/share/fonts/type1/gsfonts/c059033l.pfb: Century Schoolbook L:style=Italic
    /usr/share/fonts/type1/gsfonts/c059036l.pfb: Century Schoolbook L:style=Bold Italic
    /usr/share/fonts/type1/gsfonts/d050000l.pfb: Dingbats:style=Regular
    /usr/share/fonts/type1/gsfonts/n019003l.pfb: Nimbus Sans L:style=Regular
    /usr/share/fonts/type1/gsfonts/n019004l.pfb: Nimbus Sans L:style=Bold
    /usr/share/fonts/type1/gsfonts/n019023l.pfb: Nimbus Sans L:style=Regular Italic
    /usr/share/fonts/type1/gsfonts/n019024l.pfb: Nimbus Sans L:style=Bold Italic
    /usr/share/fonts/type1/gsfonts/n019043l.pfb: Nimbus Sans L:style=Regular Condensed
    /usr/share/fonts/type1/gsfonts/n019044l.pfb: Nimbus Sans L:style=Bold Condensed
    /usr/share/fonts/type1/gsfonts/n019063l.pfb: Nimbus Sans L:style=Regular Condensed Italic
    /usr/share/fonts/type1/gsfonts/n019064l.pfb: Nimbus Sans L:style=Bold Condensed Italic
    /usr/share/fonts/type1/gsfonts/n021003l.pfb: Nimbus Roman No9 L:style=Regular
    /usr/share/fonts/type1/gsfonts/n021004l.pfb: Nimbus Roman No9 L:style=Medium
    /usr/share/fonts/type1/gsfonts/n021023l.pfb: Nimbus Roman No9 L:style=Regular Italic
    /usr/share/fonts/type1/gsfonts/n021024l.pfb: Nimbus Roman No9 L:style=Medium Italic
    /usr/share/fonts/type1/gsfonts/n022003l.pfb: Nimbus Mono L:style=Regular
    /usr/share/fonts/type1/gsfonts/n022004l.pfb: Nimbus Mono L:style=Bold
    /usr/share/fonts/type1/gsfonts/n022023l.pfb: Nimbus Mono L:style=Regular Oblique
    /usr/share/fonts/type1/gsfonts/n022024l.pfb: Nimbus Mono L:style=Bold Oblique
    /usr/share/fonts/type1/gsfonts/p052003l.pfb: URW Palladio L:style=Roman
    /usr/share/fonts/type1/gsfonts/p052004l.pfb: URW Palladio L:style=Bold
    /usr/share/fonts/type1/gsfonts/p052023l.pfb: URW Palladio L:style=Italic
    /usr/share/fonts/type1/gsfonts/p052024l.pfb: URW Palladio L:style=Bold Italic
    /usr/share/fonts/type1/gsfonts/s050000l.pfb: Standard Symbols L:style=Regular
    /usr/share/fonts/type1/gsfonts/z003034l.pfb: URW Chancery L:style=Medium Italic
    ```
 



## headless

```bash
# download Jessie Frazelle seccomp profile for Chrome.
wget -O ~/chrome.json https://raw.githubusercontent.com/jfrazelle/dotfiles/master/etc/docker/seccomp/chrome.json

# run with seccomp
docker run --name my-chrome \
    -d \
    -p 9222:9222 \
    --security-opt seccomp=$HOME/chrome.json \
    justinribeiro/chrome-headless

```

## see
* [Support Chrome Sandboxing on Ubuntu](https://github.com/SeleniumHQ/docker-selenium/issues/487#issuecomment-302342772)
* [addyosmani/headless.md](https://gist.github.com/addyosmani/5336747)
* [Getting Started with Headless Chrome](https://developers.google.com/web/updates/2017/04/headless-chrome)
* [justinribeiro/chrome-headless](https://hub.docker.com/r/justinribeiro/chrome-headless/)

