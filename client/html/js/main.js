function showRootMenu() {
  var innerHTML = `
    <div class="col align-self-center">
      <div class="row d-flex justify-content-center py-5">
        <div class="col-3">
          <button class="btn btn-primary btn-lg btn-block border border-2 border-danger" onClick="newTreatment()">
            <div class="text-center m-3">
              <i class="fas fa-procedures fa-7x"></i>
            </div>
            <h1 class="text-center m-3">
              ${window.t['treatments']['new']}
            </h1>
          </button>
        </div>
        <div class="col-3">
          <button class="btn btn-primary btn-lg btn-block border border-2 border-danger" id="newExamination">
            <div class="text-center m-3">
              <i class="fas fa-notes-medical fa-7x"></i>
            </div>
            <h1 class="text-center m-3">
              ${window.t['examinations']['new']}
            </h1>
          </button>
        </div>
        <div class="col-3">
          <button class="btn btn-primary btn-lg btn-block border border-2 border-danger" id="newDeath">
            <div class="text-center m-3">
              <i class="fas fa-book-dead fa-7x"></i>
            </div>
            <h1 class="text-center m-3">
              ${window.t['deaths']['new']}
            </h1>
          </button>
        </div>
      </div>
    </div>
  `
  document.getElementById('app').innerHTML = innerHTML;
}

function getPlayerName() {
  $.post('http://tablet_ems/getPlayerName');
}