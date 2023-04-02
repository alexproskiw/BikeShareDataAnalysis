# <ins>Bike Share Data Analysis</ins>
> A statistical analysis of users of a bike share system in Washington DC. This is a group project for UBC STAT 306.

## <ins>Data Source:</ins>
The data being used for this project is ![Bike Rental Data](https://www.kaggle.com/datasets/prepinstaprime/bike-rental-data) found on Kaggle.

## <ins>Variables:</ins>
The dataset used contains information on bicycle rentals associated with bike-sharing systems in Washington, DC. Bike sharing is where customers can rent a bike and return it to different places across a city, often meant to reduce vehicle dependency and extend transit capability in an urban area. The Kaggle dataset doesn’t say where or how the data was obtained, although further research indicates it is likely from the Capital Bikeshare system.

Data is provided from the start of 2011 to the end of 2012. Variables measured include:
- datetime: Continuous variable broken into 1-hour segments, spanning from 2011-01-01 at 0:00 hrs to 2012-12-19 at 23:00 hrs
- season: Categorical variable (1 = January to March, 2 = April to June, 3 = July to September, 4 = October to December)
- holiday: Categorical variable (0 = not a holiday, 1 = holiday)
- workingday: Categorical variable (0 = weekend, 1 = weekday)
- weather: Categorical variable (1 = clear, 2 = mist/clouds, 3 = light rain/snow, 4 = heavy rain/snow)
- temp: Continuous variable representing the temperature at that time (units of Celsius)
- atemp: Continuous variable representing the normalized feeling temperature at that time (units of Celsius)
- humidity: Continuous variable representing the humidity at that time (normalized by 100)
- windspeed: Continuous variable representing the wind speed at that time (miles per hour normalized by 67)
- casual: Continuous variable representing the # of non-registered users renting bikes at that time
- registered: Continuous variable representing the # of registered users renting bikes at that time
- count: Continuous variable representing the total # of users (non-registered plus registered) renting bikes at that time

## <ins> Motivation and Research Questions:</ins>
With several cyclists in our group, we are accustomed to cycling all days of the week and in a variety of weather conditions. In contrast, bicycle rentals are often advertised as a fun and convenient way to enjoy a weekend while the weather is nice.

In consideration of this typical advertisement of bicycle renting, we would like to use the dataset to answer 2 main questions:
- What times of year, days of the week, and hours of the day are most common for bike rentals?
- How does weather influence the number of users renting a bike?

The findings of the analysis will allow us to assess whether the most common use case of bicycle rentals is on weekend days with nice weather, or if any other patterns might emerge.
