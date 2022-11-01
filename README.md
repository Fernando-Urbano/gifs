# GIFs with ggplot2
GIFs in R are really easy to do!

After creating a ggplot, add a "transition". There are many types of transitions, in the examples uploaded, we use `transition_reveal`.
The `transition_reveal` must have the variable that will be used to reveal. The graphic must than be saved as an object.

Later, we animate the graphic with the following function:
```
graphic_animated <- animate(
  graphic_to_animate,
  fps = 10, duration = 15,
  end_pause = 60
)
```
To save the graphic:
```
anim_save("Animation Name.gif", graphic_animated)
```


