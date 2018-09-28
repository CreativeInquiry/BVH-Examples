# IMPORTANT INFORMATION

### Chrome will fail to load the BVH file if you are working locally and not on a webserver. Follow the below instructions to start chrome with an added argument to disable this safety feature.  

### On a Mac launch Chrome from the terminal using this command:
			
```open /Applications/Google\ Chrome.app --args --allow-file-access-from-files```

or 

```python -m http.server```, then open the URL ```http://127.0.0.1:8000```

### On a Windows Machine Launch the Google Chrome browser from the command line using this command:
			
```path to your chrome installation\chrome.exe --allow-file-access-from-files```
