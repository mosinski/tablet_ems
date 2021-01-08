function showTreatments() {
  $.post('http://tablet_ems/getTreatments');
}

function getTreatments(treatments) {
  var dateOpts = { year: 'numeric', month: 'numeric', day: 'numeric', hour: 'numeric', minute: 'numeric' };
  var innerHTML = `
    <div class="col">
      <div class="row justify-content-center">
        <div class="col-4 py-5">
          <div class="input-group">
            <div class="input-group-prepend">
              <button class="btn btn-outline-secondary" type="button">
                <i class="fas fa-podcast"></i>
              </button>
            </div>
            <input type="text" class="form-control" placeholder="wyszukaj: Pacjent, Lekarz, Operacja">
          </div>
        </div>
      </div>
      <div class="row">
        <div class="col">
          <div class="table-responsive">
            <table class="table table-hover table-striped text-dark">
              <thead class="thead-dark">
                <tr>
                  <th scope="col">Pacjent</th>
                  <th scope="col">Lekarz</th>
                  <th scope="col">Operacja</th>
                  <th scope="col">Faktura</th>
                  <th scope="col">Rekonwalescencja</th>
                  <th scope="col">Data</th>
                </tr>
              </thead>
              <tbody>
                ${treatments.map(entry => (
                  `<tr><td>${entry.patient}</td><td>${entry.medic}</td><td>${entry.operations}</td><td>${entry.fee}</td><td>${new Date(entry.recoveryDate).toLocaleDateString('pl', dateOpts)}</td><td>${new Date(entry.date).toLocaleDateString('pl', dateOpts)}</td></tr>`
                )).join('')}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  `
  document.getElementById('app').innerHTML = innerHTML;
}

function newTreatment() {
  var innerHTML = `
  <div class="col">
    <form id="treatmentForm" class="text-dark pt-5 row justify-content-center" onsubmit="event.preventDefault(); createTreatment()">
      <div class="col-3 mx-2">
        <div class="row">
          <div class="form-group dropdown show">
            <label for="patient" class="col-form-label col-form-label-lg">Pacjent</label>
            <div class="input-group">
              <div class="input-group-prepend">
                <button class="btn btn-outline-secondary" type="button">
                  <i class="fas fa-podcast"></i>
                </button>
              </div>
              <input type="hidden" name="patient" id="patient">
              <input type="text" class="form-control form-control-lg" id="patientTrigger" placeholder="Imie i Nazwisko" required>
            </div>
            <div class="dropdown-menu show" id="patientList">
              <button type="button" class="dropdown-item" data-value="7">
                You can use this example to
                <span class="text-danger">test</span>
              </button>
            </div>
          </div>
        </div>
        <div class="row">
          <div class="form-group">
            <label for="details" class="col-form-label col-form-label-lg">Opis</label>
            <textarea class="form-control" name="details" rows="12" required></textarea>
          </div>
        </div>
      </div>
      <div class="col-3">
        <div class="row">
          <div class="form-group">
            <label class="col-form-label col-form-label-lg">Powrot do zdrowia</label>
            <input type="datetime-local" name="recovery" class="form-control form-control-lg" required>
          </div>
        </div>
        <div class="row">
          <div class="form-group">
            <label for="price" class="col-form-label col-form-label-lg">Kwota Faktury</label>
            <div class="input-group">
              <input type="text" class="form-control form-control-lg" name="price" placeholder="0.0" required>
              <div class="input-group-append">
                <span class="input-group-text">$</span>
              </div>
            </div>
          </div>
        </div>
        <div class="row">
          <div class="form-group">
            <label for="price" class="col-form-label col-form-label-lg">Podpis</label>
            <div id="signature-pad" class="p-2" onclick="sign()">
              <h1 id="signature">${window.player_name}</h1>
            </div>
          </div>
        </div>
        <div class="row">
          <button type="submit" class="btn btn-primary btn-block btn-lg">${window.t['save']}</button>   
        </div>
      </div>
    </form>
  </div>
  `
  document.getElementById('app').innerHTML = innerHTML;
  autocomplete(document.getElementById("patientTrigger"), []);
}

function createTreatment() {
  var data = window.jQuery('#treatmentForm').serializeArray().reduce((obj, item) => ({ ...obj, ...{ [item.name]: item.value } }), {});
  $.post('http://tablet_ems/createTreatment', JSON.stringify(data));
  setTimeout(function(){ showTreatments() }, 1000);
}

function sign() {
  var element = document.getElementById("signature");
  var name = "signed";
  var arr = element.className.split(" ");
  if (arr.indexOf(name) == -1) {
    $.post('http://tablet_ems/sign');
    element.classList.add(name);
  }
} 
