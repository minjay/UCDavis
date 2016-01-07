# I did this assignment by myself and developed and wrote the code for each part by myself,
# drawing only from class, section, Piazza posts and the Web.  I did not use code from
# a fellow student or a tutor or any other individual.

library(RSQLite)
library(plyr)

con = dbConnect(SQLite(), 'lean_imdbpy.db')
con2 = dbConnect(SQLite(), 'lean_imdbpy_2010_idx.db')

### 1

# number of movies

# In this part I will create two new tables, which I will use afterwards all the time.
# One is title_movie, which is the subset of title only containing movies. The other is
# name_actor, which is also a subset of name only containing actors. Since questions
# afterwards will keep focused on movies and actors, I will create them as temporary
# tables.

# create a new title table that only have movies, and give the table name title_movie
dbGetQuery(con, '
           CREATE TABLE title_movie AS
           SELECT DISTINCT title.*
           FROM title JOIN kind_type kt ON title.kind_id = kt.id
           WHERE kt.kind = "movie"
           ')

dbGetQuery(con, '
           SELECT COUNT(DISTINCT title_movie.id) movie_count
           FROM title_movie
           ')

# number of actors

# create a new name table that only have actors, and give the table name name_actor
dbGetQuery(con, '
           CREATE TABLE name_actor AS
           SELECT DISTINCT name.*
           FROM cast_info ci JOIN name ON ci.person_id = name.id
              JOIN role_type rt on ci.role_id = rt.id
           WHERE rt.role IN ("actor", "actress")
           ')


dbGetQuery(con, '
           SELECT count(name_actor.id) actor_count
           FROM name_actor
           ')

### 2

# year span
dbGetQuery(con, '
           SELECT MAX(production_year) year_max, MIN(production_year) year_min
           FROM title
           ')

### 3

# get the count of each gender
each_gender <- 
  dbGetQuery(con, '
             SELECT COUNT(*) gender_count, gender 
             FROM name_actor
             GROUP BY gender;
             ')

# get the total count
total_number_gender <- 
  dbGetQuery(con, '
             SELECT COUNT(*)
             FROM name_actor
             ')

# propotionalized
each_gender$gender_count <- each_gender$gender_count / total_number_gender[[1]]

# return result
each_gender

### 4

# get the count of type
each_kind <- 
  dbGetQuery(con, '
             SELECT COUNT(*) type_count, kt.kind 
             FROM title JOIN kind_type kt ON title.kind_id = kt.id
             GROUP BY kt.kind
             ')

# get the total number
total_number_kind <- 
  dbGetQuery(con, '
             SELECT COUNT(*)
             FROM title
             ')

# proportionalize
each_kind$type_count <- each_kind$type_count / total_number_kind[[1]]

# print result
each_kind

### 5

# get the number of genres
dbGetQuery(con, '
           SELECT COUNT(*) genre_count
           FROM (
              SELECT mi.info
              FROM info_type it JOIN movie_info mi ON it.id = mi.info_type_id
                  JOIN title_movie tm ON mi.movie_id = tm.id
              WHERE it.info = "genres"
              GROUP BY mi.info
           )
           ')

# get all genres
dbGetQuery(con, '
           SELECT mi.info
           FROM info_type it INNER JOIN movie_info mi ON it.id = mi.info_type_id
              INNER JOIN title_movie tm ON mi.movie_id = tm.id
           WHERE it.info = "genres"
           GROUP BY mi.info
           ')

# What if we want genres from all movies and tvs and others?
dbGetQuery(con, '
           SELECT COUNT(*) genre_count
           FROM (
              SELECT mi.info
              FROM info_type it JOIN movie_info mi ON it.id = mi.info_type_id
                  JOIN title tm ON mi.movie_id = tm.id
              WHERE it.info = "genres"
              GROUP BY mi.info
           )
           ')

### 6

# the 10 most common genres of movies, showing the number of movies in each of 
# these genres
top_10_genres <- 
  dbGetQuery(con, '
             SELECT mi.info, COUNT(mi.info) genre_count
             FROM info_type it INNER JOIN movie_info mi ON it.id = mi.info_type_id
                INNER JOIN title_movie tm ON mi.movie_id = tm.id
             WHERE it.info = "genres"
             GROUP BY mi.info
             ORDER BY genre_count DESC
             LIMIT 10
             ')

top_10_genres

### 7

# all movies with the keyword 'space'
movie_space <-
  dbGetQuery(con, '
             SELECT tm.id, tm.title
             FROM title_movie tm INNER JOIN movie_keyword mk ON tm.id = mk.movie_id
                INNER JOIN keyword kw ON mk.keyword_id = kw.id
             WHERE kw.keyword = "space"
             ')

head(movie_space)
summary(movie_space)

# count
dbGetQuery(con, '
           SELECT COUNT(*) space_count
           FROM title_movie tm INNER JOIN movie_keyword mk ON tm.id = mk.movie_id
              INNER JOIN keyword kw ON mk.keyword_id = kw.id
           WHERE kw.keyword = "space"
           ')

# years
movie_space_year <- 
  dbGetQuery(con, '
             SELECT DISTINCT tm.production_year
             FROM title_movie tm INNER JOIN movie_keyword mk ON tm.id = mk.movie_id
                INNER JOIN keyword kw ON mk.keyword_id = kw.id
             WHERE kw.keyword = "space" AND tm.production_year IS NOT NULL
             ORDER BY tm.production_year
             ')

movie_space_year$production_year

# top n actors with each movie

movie_space_top_actor_each <- function(n) {
  # This is the function that gives the result of top 5 movies with n movies. So if
  # you want the data for the first 10 movies, just give the argument n = 10, and this
  # is what I do afterwards.
  
  top_actor <- lapply(movie_space[['id']][1:n], function(x) {
                dbGetQuery(con, paste('
                           SELECT na.id, na.name, ci.nr_order
                           FROM title_movie tm JOIN cast_info ci ON tm.id = ci.movie_id
                              JOIN name_actor na ON na.id = ci.person_id
                           WHERE tm.id =', x, '
                           AND ci.nr_order IN (1, 2, 3, 4, 5, 6)
                           GROUP BY na.id
                           ORDER BY ci.nr_order
                           LIMIT 5'
                           ))
              })
  
  names(top_actor) <- movie_space[['name']][1:n]
  
  top_actor
}

movie_space_top_actor_total <- movie_space_top_actor_each(10)

### 8

# The number of genres over time
genre_year <- 
  dbGetQuery(con, '
                  SELECT mi.info genre, tm.production_year year, COUNT(mi.info) genre_count
                  FROM info_type it JOIN movie_info mi ON it.id = mi.info_type_id
                      JOIN title_movie tm ON mi.movie_id = tm.id
                  WHERE it.info = "genres" AND 
                      tm.production_year IS NOT NULL AND 
                      genre IS NOT NULL
                  GROUP BY mi.info, tm.production_year
                  ')

library(ggplot2)
ggplot(genre_year, aes(year, genre_count)) + 
  geom_point() + 
  facet_wrap(~ genre, scales = 'free')

# 9-12 are using small dataset

# To be consistent, I will also create two tables as before, which are movies and actors
dbGetQuery(con2, '
           CREATE TABLE title_movie2 AS
           SELECT DISTINCT title2.*
           FROM title2 JOIN kind_type kt ON title2.kind_id = kt.id
           WHERE kt.kind = "movie"
           ')

dbGetQuery(con2, '
           CREATE TABLE name_actor2 AS
           SELECT DISTINCT name2.*
           FROM cast_info2 ci JOIN name2 ON ci.person_id = name2.id
           JOIN role_type rt on ci.role_id = rt.id
           WHERE rt.role IN ("actor", "actress")
           ')

### 9

# Top 20 actors in movies

# SQL approach
dbGetQuery(con2, '
           SELECT na.id, na.name, COUNT(*) actor_count
           FROM cast_info2 ci JOIN name_actor2 na ON ci.person_id = na.id
              JOIN title_movie2 tm ON tm.id = ci.movie_id
           GROUP BY na.id
           ORDER BY actor_count DESC
           LIMIT 20
           ')

# R approach
actors <- 
  dbGetQuery(con2, '
             SELECT na.id, na.name
             FROM cast_info2 ci JOIN name_actor2 na ON ci.person_id = na.id
                JOIN title_movie2 tm ON tm.id = ci.movie_id
             ')

actors_count <- ddply(actors, .(id, name), nrow)
head(actors_count[order(actors_count$V1, decreasing = T), ], n = 20)

### 10

# top billing

# SQL approach
billing_top_10 <- 
  dbGetQuery(con2, '
             SELECT na.id, na.name, COUNT(na.id) actor_billing_count, 
                MIN(tm.production_year) min_year, MAX(tm.production_year) max_year
             FROM name_actor2 na JOIN cast_info2 ci on na.id = ci.person_id
                JOIN title_movie2 tm ON tm.id = ci.movie_id
             WHERE ci.nr_order IN (1, 2, 3)
             GROUP BY na.id
             ORDER BY COUNT(na.id) DESC
             LIMIT 10
             ')

# R approach
billing_data <- 
  dbGetQuery(con2, '
             SELECT na.id, na.name, tm.production_year, ci.nr_order
             FROM name_actor2 na JOIN cast_info2 ci on na.id = ci.person_id
                JOIN title_movie2 tm ON tm.id = ci.movie_id
             ')

billing_top_data <- billing_data[billing_data$nr_order %in% c(1, 2, 3), -4]
billing_top_data_count <- ddply(billing_top_data, .(id, name), nrow, 
                                max_year = max(production_year), min_year = min(production_year), 
                                .drop = FALSE)
billing_top_data_count_head <- 
  head(billing_top_data_count[order(billing_top_data_count$V1, decreasing = T), ], n = 10)

### 11

# SQL approach

top_10_actors_within_year <- 
  dbGetQuery(con2, '
             SELECT na.id, na.name, COUNT(*) actor_count, tm.production_year
             FROM title_movie2 tm JOIN cast_info2 ci ON tm.id = ci.movie_id 
                JOIN name_actor2 na ON ci.person_id = na.id
             GROUP BY tm.production_year, na.id
             ORDER BY actor_count DESC
             LIMIT 10
             ')

top_10_actors_movies <-
  lapply(1:10, function(i) {
    dbGetQuery(con2, paste('
               SELECT tm.id, tm.title
               FROM title_movie2 tm JOIN cast_info2 ci ON tm.id = ci.movie_id 
                   JOIN name_actor2 na ON ci.person_id = na.id
               WHERE tm.production_year =', top_10_actors_within_year[i, 'production_year'], ' 
                   AND na.id = ', top_10_actors_within_year[i, 'id'], '
               LIMIT 5
               '))
  })

names(top_10_actors_movies) <- paste(top_10_actors_within_year[['name']], 'at year', 
                                     top_10_actors_within_year[['production_year']])

top_10_actors_movies

# R approach

top_10_actors_within_year_data <-
  dbGetQuery(con2, '
             SELECT na.id, na.name, tm.production_year
             FROM title_movie2 tm JOIN cast_info2 ci ON tm.id = ci.movie_id 
                JOIN name_actor2 na ON ci.person_id = na.id
             ')

top_10_actors_within_year_data_count <- 
  ddply(top_10_actors_within_year_data, .(id, name, production_year), nrow)

top_10_actors_within_year_data_count_result <- 
  head(top_10_actors_within_year_data_count[order(top_10_actors_within_year_data_count$V1, decreasing = T), ], n = 10)

### 12

# 10 actors that have the most aliases

# SQL Approach
dbGetQuery(con2, '
           SELECT na.id, na.name, COUNT(*) alias_count
           FROM name_actor2 na JOIN aka_name2 an ON na.id = an.person_id
           GROUP BY na.id
           ORDER BY alias_count DESC
           LIMIT 10')

# R Approach
name_with_alias <- dbGetQuery(con2, '
                              SELECT na.id, na.name, an.name alias
                              FROM name_actor2 na JOIN aka_name2 an ON na.id = an.person_id
                              ')

name_with_alias_count <- ddply(name_with_alias, .(id, name), nrow)
head(name_with_alias_count[order(name_with_alias_count$V1, decreasing = T), ], n = 10)


### 13

# In this question, my approach is as follows:

# Since the main idea is to find the mapping between movie and actor, so it is a good method
# create a temporary table that map the movie name and id to the actor name and id. Since I
# have already created the temporary table in the beginning of this homework, so what I need
# to do now is to use the cast_info table to join them together. I give the final table a
# name of movie_actor.
dbGetQuery(con, '
           CREATE TEMPORARY TABLE movie_actor AS
           SELECT DISTINCT tm.id movie_id, tm.title movie_title, 
              na.id actor_id, na.name actor_name
           FROM title_movie tm JOIN cast_info ci ON tm.id = ci.movie_id
              JOIN name_actor na ON ci.person_id = na.id
           ')

# The function vector_to_sql_id is a tranformation from dataframe-like id vector to sql-like
# id vector. For instance, we can get a vector of 1, 2, 3 in R, but in sql, what we need
# is (1, 2, 3) and nothing else. So this function calls the paste(paste0) function twice to
# combine all the elements together.
vector_to_sql_id <- function(vector) {
  paste0('(', paste(vector, collapse = ','), ')')
}

# First I get the dataframe for actors movies count:

movie_actor_count <- 
  dbGetQuery(con, '
             SELECT actor_id, actor_name, COUNT(*) actor_count
             FROM movie_actor
             GROUP BY actor_id
             ')

# Now it is time to select which actor we are going to plot its movie network. Before this,
# I need to mention that, the number of actors are increasing in a very rapid speed. To
# avoid the large number of final set of actors, I will select a very small number of movies
# with respect to the initial actor,  and also a very small number of first set of actors 
# related to the initial actor. But it is very computationally expensive, so I only select
# the actor with only 20 movies and minimize the number of first set of actors in the first
# 100 such actors.

# Note here, the words initial, first and second I refer to previously and afterwards are:
# The initial stands for the initial actor I select; The first represents the first set
# of movies related to this initial actor and the first set of actors related to the first 
# set of actors; The second set represents the second set of movies related to the first
# set of actors and the second set of actors related to the second set of movies. This
# convention of naming will also be used afterwards when calculating the correspondent
# dataframes and vectors.

# calculate is such a function that calculates the first 100 first set of actor numbers
calculate_first_actor_count <- function(id) {
  # This function first calculates the first set of movies, then calculate the count
  # of first set of actors.
  
  # calculate the first set of movies
  first_movie <- 
    dbGetQuery(con, paste('
               SELECT movie_id, movie_title
               FROM movie_actor
               WHERE actor_id =', id
               ))
  
  # give the count of first set of actors
  first_actor_counts <- 
    dbGetQuery(con, paste('
               SELECT COUNT(DISTINCT actor_id)
               FROM movie_actor
               WHERE movie_id IN', vector_to_sql_id(first_movie[['movie_id']])
    ))
  
  # get the count
  first_actor_counts[1,1]
}

# call the calculate_first_actor_count function to calculate the first set actors count for 
# the first 100 initial actors
first_100_compare <- 
  sapply(movie_actor_count[movie_actor_count$actor_count == 20, ][1:100, ][['actor_id']], 
            calculate_first_actor_count)

# The value for the 90th value is the smallest. So to avoid too large vertices and edges,
# I will select that value.
movie_actor_count[movie_actor_count$actor_count == 20, ][90, ]
# So I will select actor id 76422

# Now I will calculate the second set of movies and second set of actors following the
# logic of initial actor, first set of movies, first set of actors, second set of movies,
# second set of actors.

# give the initial actor value
initial_actor <- 76422

# calculate first set of movies, based on initial actor
first_movie <- 
  dbGetQuery(con, paste('
             SELECT DISTINCT movie_id, movie_title
             FROM movie_actor
             WHERE actor_id =', initial_actor
             ))

# calculate first set of actors, based on first set of movies
first_actor <- 
  dbGetQuery(con, paste('
             SELECT DISTINCT actor_id, actor_name
             FROM movie_actor
             WHERE movie_id IN', vector_to_sql_id(first_movie[['movie_id']])
             ))

# calculate second set of movies, based on first set of actors
second_movie <- 
  dbGetQuery(con, paste('
              SELECT DISTINCT movie_id, movie_title
              FROM movie_actor
              WHERE actor_id IN', vector_to_sql_id(first_actor[['actor_id']])
              ))

# calculate second set of actors, based on second set of movies
second_actor <-
  dbGetQuery(con, paste('
             SELECT DISTINCT actor_id, actor_name
             FROM movie_actor
             WHERE movie_id IN', vector_to_sql_id(second_movie[['movie_id']])
             ))

# Now I have second hand of movies, then what I should do now is to just extract all the
# actors in each movie and create a link between them, whenever they emerge in the same
# movie. After that, I will combine all the links from different movies together. I know
# there will be some duplications, then I use the ddply function from plyr package to
# remove the rebundancies and give any replicated values weight equal to the number of
# replications.

create_connection_single <- function(name_A, name_B) {
  # First, for each actor A and B, create a link between them
  
  data.frame(first = name_A, second = name_B)
}

create_connection_movie <- function(id_movie) {
  # Second, for each movie, create all links between all actors, and then combine them together
  
  # extract relevent actor id by movie id
  id_actors <- dbGetQuery(con, paste('
                          SELECT DISTINCT actor_id, actor_name
                          FROM movie_actor
                          WHERE movie_id =', id_movie
                          ))
  
  # get all actor id
  id_actors <- id_actors[['actor_id']]
  
  # get the number of all actors
  N <- length(id_actors)
  
  # I will do two loops here, the inner loop and the outer loop. Based on these two lapply,
  # I will create a link for each combination of actors
  outer_result <- lapply(1:N, function(i) {
    inner_result <- lapply(i:N, function(j) {
      if (i!= j) create_connection_single(id_actors[i], id_actors[j])
    })
    do.call(rbind, inner_result)
  })
  
  # combine the results into a big dataframe
  final_result <- do.call(rbind, outer_result)
  
  # return result
  final_result
}

create_connection_movies <- function(second_movie) {
  # Third, based on a list of movies, I will call create_connection_movie to get the 
  # dataframe for each movie, and then combine the dataframes together to make the
  # final dataframe. Of course I use ddply to remove duplicates and counts the
  # duplications as a new variable, weight.
  
  # get movie vector
  id_movies <- second_movie[['movie_id']]
  
  # call create_connection_movie to get a list of dataframes of links related to
  # each movie
  each_movie_list <- lapply(id_movies, create_connection_movie)
  
  # combine them together
  movie_total_connection <- do.call(rbind, each_movie_list)
  
  # use ddply to remove duplicates
  movie_unique_connection <- ddply(movie_total_connection, .(first, second), nrow)
  names(movie_unique_connection)[3] <- 'weight'
  
  # return value
  movie_unique_connection
}

# Call the create_connection_movies with the input we get previously, second_movie
connection_data <- create_connection_movies(second_movie)

# The last part is to plot the results out. Since the dataframe I get now is particularly
# designed for this use, no further transformation or processing is required,
# except for I need to convert it to the object class of this package. Then call the plot
# function with proper parameters, everything is done.

library(igraph)
# convert to graph.data.frame
connection_network <- graph.data.frame(connection_data, directed = F)
# give different groups of actor different color. Since we have three groups: initial actor,
# first set of actors and second set of actors, I will give them different colors: red, blue
# and green respectively.
V(connection_network)$color <- 
  ifelse(V(connection_network)$name %in% initial_actor, 'red', 
         ifelse(V(connection_network)$name %in% first_actor[['actor_id']], 'blue', 'black'))

V(connection_network)$new_name <- 
  dbGetQuery(con, paste('
             SELECT name.name
             FROM name
             WHERE name.id IN', vector_to_sql_id(V(connection_network)$name)
             ))
V(connection_network)$new_name <- V(connection_network)$new_name[[1]]

V(connection_network)$degree <- degree(connection_network)
V(connection_network)$size <- V(connection_network)$degree / 30
V(connection_network)$label.cex <- 1.0 * V(connection_network)$degree / 
  max(V(connection_network)$degree) + 0.2
V(connection_network)$label.color <- 
  ifelse(V(connection_network)$name %in% initial_actor, 'red', 
          ifelse(V(connection_network)$name %in% first_actor[['actor_id']], 'blue', 'black'))
# plot results out

par(mai=c(0,0,1,0)) 

plot(connection_network,
     # the layout is chosen to best represent the data
     main = 'Connection for Armenta, Mark',
     layout=layout.kamada.kawai,
     vertex.label.dist = 0.1,			
     vertex.frame.color = 'white',
     vertex.label.font = 2,		
     vertex.label = V(connection_network)$new_name
)

# legend(1e-10, 1e-10, 
#        c('initial actor', 'first set actor', 'second set actor'), 
#        lty = 1,
#        col = c('red', 'blue', 'black'), 
#        bty='n', 
#        cex=.75)

### Question 14

# This is a subquery, since I need the movie stars,
dbGetQuery(con, '
           SELECT title.id, title.title, COUNT(DISTINCT ci.person_id) actor_count
           FROM title JOIN cast_info ci on title.id = ci.movie_id
              JOIN (SELECT DISTINCT ci.person_id mvnr_id
                    FROM title_movie tm JOIN cast_info ci ON tm.id = ci.movie_id
                    WHERE ci.nr_order IN (1, 2, 3, 4, 5)
                    ) mvnr ON ci.person_id = mvnr.mvnr_id
           WHERE ci.role_id IN (1,2)
              AND title.kind_id = 2
           GROUP BY ci.movie_id
           ORDER BY actor_count DESC
           LIMIT 10
           ')