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
      <div class="row justify-content-center py-5">
        <form id="treatmentForm" class="text-dark" action="#" method="post" onsubmit="createTreatment()">
          <div class="form-group">
            <label for="patient">Pacjent</label>
            <div class="input-group">
              <div class="input-group-prepend">
                <button class="btn btn-outline-secondary" type="button">
                  <i class="fas fa-podcast"></i>
                </button>
              </div>
              <input type="text" class="form-control" id="patient" placeholder="Imie i Nazwisko" required>
            </div>
          </div>
          <div class="form-group">
            <label for="details">Opis</label>
            <textarea class="form-control" id="details" rows="5" required></textarea>
          </div>
          <div class="form-group">
            <label>Powrot do zdrowia</label>
            <input type="datetime-local" id="recovery" name="recovery" class="form-control" required>
          </div>
          <div class="form-group">
            <label for="price">Kwota Faktury</label>
            <input type="text" class="form-control" id="price" placeholder="0.0" required>
          </div>
          <button type="submit" class="btn btn-primary">${window.t['save']}</button>
        </form>
      </div>
    </div>
  `
  document.getElementById('app').innerHTML = innerHTML;
}

function createTreatment() {
  const data = $("#treatmentForm").serializeArray().reduce((obj, item) => ({ ...obj, ...{ [item.name]: item.value } }), {});
  $.post('http://tablet_ems/createTreatment', JSON.stringify(data));
}