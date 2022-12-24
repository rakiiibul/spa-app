---
editor_options: 
  markdown: 
    wrap: 72
---

# CPA_shinyR

::: {align="center"}
<a href="https://github.com/rakiiibul/PAnSA_shinyR"></a>

<h2 align="center">

Soccer Player Attributes

</h2>

<p align="center">

with R Program Language <br />\
<a href="https://github.com/rakiiibul/PAnSA_shinyR/issues">Report
Bug</a> ·
<a href="https://github.com/rakiiibul/PAnSA_shinyR/issues">Request
Feature</a>

</p>
:::

<!-- TABLE OF CONTENTS -->

<details>

<summary>Table of Contents</summary>

<ol>

<li>

<a href="#about-the-project">About The Project</a>

<ul>

<li><a href="#built-with">Built With R </a></li>

</ul>

</li>

<li>

<a href="#getting-started">Getting Started</a>

<ul>

</li>

<li><a href="#roadmap">Roadmap</a></li>

<li><a href="#contributing">Contributing</a></li>

<li><a href="#license">License</a></li>

<li><a href="#contact">Contact</a></li>

<li><a href="#acknowledgments">Acknowledgments</a></li>

</ol>

</details>

<!-- ABOUT THE PROJECT -->

## About The Project

##Image

### Context

#### Problem Statement

Football, more commonly known as soccer, is a team sport played between
two teams of 11 players who primarily use their feet to propel the ball
around a rectangular field called a pitch.

The FIFA ***World Cup Qatar*** 2022™ has been played from 20 November to
18 December. So basically its Soccer season. The excitement for football
is very high to everyone. In this workshop, we explore the soccer player
attributes. We explore single player attributes, compare 1 player
attributes to another and also see top n player attributes in the radar
plot.

**About this Dataset**

## **The ultimate Soccer database for data analysis**

-   +25,000 matches

-   +10,000 players

-   11 European Countries with their lead championship

-   Seasons 2008 to 2016

-   Players and Teams' attributes\* sourced from EA Sports' FIFA video
    game series, including the weekly updates

-   Team line up with squad formation (X, Y coordinates)

-   Betting odds from up to 10 providers

-   Detailed match events (goal types, possession, corner, cross, fouls,
    cards etc...) for +10,000 matches

<p align="right">

(<a href="#top">back to top</a>)

</p>

### Built With

-   [R](https://www.r-project.org/)

    <p align="right">

    (<a href="#top">back to top</a>)

    </p>

<!-- GETTING STARTED -->

## Getting Started

To run this workshop, you can go with three different mode:

-   Development Mode( if you want to run the workshop and modify it in
    R)  
-   Production mode( You want to run it with docker in your own machine)
-   Visitor mode(You just want to see the project, just visit website )

##Development Mode\
\### Prerequisites

#### Tools

-   R
-   R Studio

#### Library

-   shiny

<!-- -->

        install.packages('shiny')

-   tibble

<!-- -->

        install.packages("tibble")

-   dplyr

<!-- -->

        install.packages("dplyr")

-   radarchart

<!-- -->

        install.packages("radarchart")

-   tidyr

<!-- -->

        install.packages("tidyr")

-   DT

<!-- -->

        install.packages("DT")

-   fmsb

<!-- -->

        install.packages("fmsb")

### Installation

``` sh
git clone https://github.com/rakiiibul/PAnSA_shinyR.git
```

    renv::restore()
    renv::activate() 

<p align="right">

(<a href="#top">back to top</a>)

</p>

<!-- ROADMAP -->

## Roadmap

-   [x] Description Of Data
-   [x] Data Preprocessing
-   [x] Radarchart
-   [x] Single player Attributes
-   [x] 1 vs 1 player Attributes
-   [x] Top n player Attributes


<p align="right">

(<a href="#top">back to top</a>)

</p>

<!-- LICENSE -->

## License

Distributed under the MIT License. See `LICENSE` for more information.

<p align="right">

(<a href="#top">back to top</a>)

</p>

<!-- CONTACT -->

## Contact

Project Link: <https://github.com/rakiiibul/PAnSA_shinyR>

<p align="right">

(<a href="#top">back to top</a>)

</p>

<!-- ACKNOWLEDGMENTS -->

## Acknowledgments

The data was sourced from:

<http://football-data.mx-api.enetscores.com/> : scores, lineup, team
formation and events

<http://www.football-data.co.uk/> : betting odds. Click here to
understand the column naming system for betting odds:

<http://sofifa.com/> : players and teams attributes from EA Sports FIFA
games. FIFA series and all FIFA assets property of EA Sports.

<p align="right">

(<a href="#top">back to top</a>)

</p>

<!-- MARKDOWN LINKS & IMAGES -->

<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
