import markdown, sys
import xml.etree.ElementTree as ET
xml = "<xml>" + markdown.markdown(open('README.md', encoding="utf-8").read(), extensions=['markdown.extensions.tables']) + "</xml>"
root = ET.fromstring(xml)
head = """<!DOCTYPE html>
  <html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Modelica Specification</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.5.0/css/bootstrap.min.css" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/docsearch.js@2/dist/cdn/docsearch.min.css" />
    <link rel="stylesheet" href="https://doc.modelica.org/Modelica%203.2.3/Resources/helpOM/style.css" />
  </head>
  <body class="md-body">
    <nav class="navbar navbar-light bg-light">
      <div class="container justify-content-between flex-nowrap">
        <span class="navbar-brand mb-0">
          <a href="https://modelica.org/"><img src="https://raw.githubusercontent.com/modelica/MA-Logos/master/HighRes/Modelica_Language.svg" alt="Modelica Language logo" class="md-logo"></a>
        </span>
        <div id="head-selects"></div>
      </div>
    </nav>
    <div class="container pt-4">
      <h1 class="pt-2 h2">Modelica Specification</h1>
"""
tail = """    </div>

    <div class="container">
      <template id="md-tool-select">
        <div class="md-item p-0">
          <form class="form-inline align-items-end">
            <input type="text" placeholder="Type your search..." class="form-control form-control-sm md-search-input mb-2 mr-sm-2">
            <div class="input-group mb-2 mr-sm-2">
                <select class="form-control form-control-sm md-item__version-select"></select>
            </div>
            <div class="input-group mb-2 mr-sm-2">
                <a href="#" target="_blank" rel="noopener" class="btn btn-outline-secondary btn-sm btn-block md-item__link">Browse</a>
            </div>
          </form>
        </div>
      </template>
      <template id="md-tool-template">
        <div class="md-item p-0">
          <div class="md-item__description">Description</div>
        </div>
      </template>

      <div id="container" class="pb-4"></div>
    </div>
  </body>

  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
  <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/docsearch.js@2/dist/cdn/docsearch.min.js"></script>

  <script>
    var data = {
      "versions": ["3.7-dev", "3.6", "3.5", "3.4"]
    };

    var buildSelect = function(select, data){
      while(select.firstChild) select.removeChild(select.firstChild);
      data.forEach(function (item) {
        var option = document.createElement('option');
        option.textContent = item;
        option.value = item;
        select.appendChild(option);
      });
      select[1].selected = 1;
    };

    var initSelects = function(versions){
      var container = document.createElement('div');

      var template = document.getElementById('md-tool-select');
      var clone = document.importNode(template.content, true);

      buildSelect(clone.querySelector('.md-item__version-select'), versions);

      clone.querySelector('.md-item__link').setAttribute('href', buildLink(versions[1]));

      container.appendChild(clone);
      document.getElementById('head-selects').appendChild(container);
    }

    var buildLink = function(version){
      var link = '';
      if(version == '3.7-dev'){
        link = 'https://specification.modelica.org/master/MLS.html';
      }else{
        link = 'https://specification.modelica.org/maint/' + version + '/MLS.html';
      }
      return link;
    }

    var updateSearch = function(version){
      if(version == '3.7-dev'){
        search.algoliaOptions.facetFilters = [
          "version:master",
          "tags:specification",
        ]
      }else{
        search.algoliaOptions.facetFilters = [
          "version:" + version,
          "tags:specification",
        ]
      }
    }

    $(document).ready(function() {
      initSelects(data.versions);

      $('body').on('change', '.md-item__version-select', function(){
        var version = $(this).val();
        var link = buildLink(version);

        $('.md-item').find('.md-item__link').attr('href', link);

        updateSearch(version);
      });


      search = docsearch({
        apiKey: '97b18f2173101844a41539b817e99337',
        indexName: 'modelica',
        inputSelector: '.md-search-input',
        debug: false, // Set debug to true if you want to inspect the dropdown
        algoliaOptions: {
          advancedSyntax: true,
          typoTolerance: false,
          hitsPerPage: 16,
          facetFilters: ["version:3.6", "tags:specification"]
        }
      });
    });
  </script>

</html>
"""
for elem in root.findall('.//table'):
  with open("index.html", "w") as f:
    f.write(head)
    f.write(ET.tostring(elem).decode('utf-8'))
    f.write(tail)
  sys.exit(0)
sys.exit(1)
