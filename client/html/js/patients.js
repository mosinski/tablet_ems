function closePatientList() {
  var element = document.getElementById("patientList");
  if (element) {
    element.innerHTML = "";
    element.classList.remove("show");
  }
}

function selectPatient(id, name) {
  var element1 = document.getElementById("patient");
  var element2 = document.getElementById("patientTrigger");
  element1.value = id;
  element2.value = name;
  closePatientList();
}

function autocompletePatients(patients) {
  var b, i, element = document.getElementById("patientList");
  closePatientList();

  for (i = 0; i < patients.length; i++) {
    b = document.createElement("button");
    b.innerHTML = patients[i]['name'];
    b.classList.add("dropdown-item");
    b.setAttribute("onclick","selectPatient('" + patients[i]['identifier'] + "', '" + patients[i]['name'] + "')");
    element.appendChild(b);
  }

  element.classList.add("show");
}

function autocomplete(inp, arr) {
  var currentFocus;

  inp.addEventListener("input", function(e) {
    closePatientList();

    var val = this.value;

    if (!val) { return false }
    currentFocus = -1;

    $.post('http://tablet_ems/fillPatients', JSON.stringify(val));
  });

  document.addEventListener("click", function (e) {
    closePatientList();
  });
}

function getClosestPatient() {
  $.post('http://tablet_ems/getClosestPlayer');
}