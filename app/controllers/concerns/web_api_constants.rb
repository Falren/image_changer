module WebApiConstants
  BASE_URL = 'https://api-service.vanceai.com/web_api/v1/'

  API_URL = {
    transform: 'transform',
    upload: 'upload',
    download: 'download',
    progress: 'progress'
  }

  JCONFIG = {
    sketch: {
      "job": "sketch",
      "config": {
        "module": "sketch",
        "module_params": {
          "model_name": "SketchStable",
          "single_face": true,
          "composite": true,
          "sigma": 0,
          "alpha": 0
        },
        "out_params": {}
      }
    },
    cartoonize: {
      "job": "cartoonize",
      "config": {
        "module": "cartoonize",
        "module_params": {
          "model_name": "CartoonizeStable"
        }
      }
    }
  }
end
