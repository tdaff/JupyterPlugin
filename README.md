# JupyterPlugin

### Foswiki plugin to enable rendering of Jupyter notebooks in wiki pages

The plugin needs to be manually installed into the wiki (sorry).
It requires ``nbconvert`` installed on the machine rendering
the wiki. The path to the command can be configured in settings.

To use the plugin:

* Attach the notebook file to the topic.
* Invoke the plugin where you would like the page rendered:
  ``%JUPYTER{filename.ipynb}%``
* Note that the processed files is not cached, so it may
  slow down rendering pages with notebooks.
